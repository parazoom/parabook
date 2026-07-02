import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';
import '../../models/jump.dart';
import '../../models/drop_zone.dart';
import '../../models/jump_type.dart';
import '../../models/aircraft.dart';
import '../../models/equipment.dart';
import '../../models/jump_filter.dart';
import 'add_jump_screen.dart';
import 'jump_detail_screen.dart';

class JumpsScreen extends ConsumerStatefulWidget {
  const JumpsScreen({super.key});

  @override
  ConsumerState<JumpsScreen> createState() => _JumpsScreenState();
}

class _JumpsScreenState extends ConsumerState<JumpsScreen> {
  static const _pageSize = 100;
  final _jumps = <Jump>[];
  final _scrollCtrl = ScrollController();
  bool _loading = false;
  bool _hasMore = true;
  int? _lastNum;
  JumpFilter _filter = const JumpFilter();

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_loading && _hasMore) {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 600) _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    final rows = await ref.read(jumpsDaoProvider).getPage(_pageSize, beforeNum: _lastNum, filter: _filter);
    if (!mounted) return;
    setState(() {
      _jumps.addAll(rows);
      if (rows.isNotEmpty) _lastNum = rows.last.num;
      _hasMore = rows.length == _pageSize;
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() { _jumps.clear(); _hasMore = true; _lastNum = null; _loading = false; });
    await _loadMore();
  }

  Future<void> _openFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<JumpFilter>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(filter: _filter),
    );
    if (result == null || !mounted) return;
    setState(() => _filter = result);
    await _refresh();
  }

  void _clearFilters() {
    setState(() => _filter = const JumpFilter());
    _refresh();
  }

  Future<void> _copyLast(BuildContext context) async {
    final last = await ref.read(jumpsDaoProvider).getLast();
    if (!context.mounted) return;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => AddJumpScreen(copyFrom: last)));
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Column(
          children: [
            if (_filter.isActive) _FilterBanner(l: l, onClear: _clearFilters),
            Expanded(
              child: _jumps.isEmpty && _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _jumps.isEmpty
                      ? Center(child: Text(_filter.isActive ? l.noJumpsFiltered : l.noJumps))
                      : _JumpsList(jumps: _jumps, l: l, scrollCtrl: _scrollCtrl, loading: _loading, onUpdated: _refresh),
            ),
          ],
        ),
        Positioned(
          bottom: 24 + MediaQuery.of(context).padding.bottom,
          right: 16 + MediaQuery.of(context).padding.right,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'search_jumps',
                backgroundColor: _filter.isActive ? Theme.of(context).colorScheme.primary : null,
                onPressed: () => _openFilterSheet(context),
                child: const Icon(Icons.search),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'copy_last_jumps',
                onPressed: () => _copyLast(context),
                child: const Icon(Icons.copy),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'add_jump_jumps',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddJumpScreen()),
                ).then((_) => _refresh()),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _JumpsList extends ConsumerWidget {
  final List<Jump> jumps;
  final AppLocalizations l;
  final ScrollController scrollCtrl;
  final bool loading;
  final VoidCallback onUpdated;

  const _JumpsList({required this.jumps, required this.l, required this.scrollCtrl, required this.loading, required this.onUpdated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dzList = ref.watch(dropZonesProvider).value ?? [];
    final jtList = ref.watch(jumpTypesProvider).value ?? [];
    final aircraftList = ref.watch(aircraftProvider).value ?? [];
    final bagList = ref.watch(bagsProvider).value ?? [];
    final canopyList = ref.watch(canopiesProvider).value ?? [];
    final suitList = ref.watch(suitsProvider).value ?? [];
    final dzMap = <int?, DropZone>{for (final d in dzList) d.id: d};
    final jtMap = <int?, JumpType>{for (final t in jtList) t.id: t};
    final aircraftMap = <int?, Aircraft>{for (final a in aircraftList) a.id: a};
    final bagMap = <int?, Equipment>{for (final e in bagList) e.id: e};
    final canopyMap = <int?, Equipment>{for (final e in canopyList) e.id: e};
    final suitMap = <int?, Equipment>{for (final e in suitList) e.id: e};
    final residenceCountry = ref.watch(settingsProvider).residenceCountry;

    final sysPadding = MediaQuery.of(context).padding;
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
      children: [
        _TableHeader(l: l),
        Expanded(
          child: ListView.builder(
            controller: scrollCtrl,
            padding: EdgeInsets.only(bottom: 100 + sysPadding.bottom),
            itemCount: jumps.length + (loading ? 1 : 0),
            itemBuilder: (context, i) {
              if (i == jumps.length) {
                return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
              }
              final jump = jumps[i];
              return _JumpRow(
                jump: jump,
                l: l,
                dz: dzMap[jump.dropZoneId],
                jt: jtMap[jump.jumpTypeId],
                aircraft: aircraftMap[jump.aircraftId],
                bag: bagMap[jump.bagId],
                canopy: canopyMap[jump.canopyId],
                suit: suitMap[jump.suitId],
                residenceCountry: residenceCountry,
                onUpdated: onUpdated,
              );
            },
          ),
        ),
      ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final AppLocalizations l;
  const _TableHeader({required this.l});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final style = TextStyle(fontWeight: FontWeight.bold, color: primary);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: primary.withAlpha(100)))),
      child: Row(children: [
        SizedBox(width: 48, child: Text(l.num, style: style)),
        Expanded(flex: 2, child: Text('${l.location} / ${l.country}', style: style)),
        Expanded(flex: 2, child: Text('${l.date} / ${l.type}', style: style)),
        if (isLandscape) ...[
          Expanded(flex: 2, child: Text(l.aircraft, style: style)),
          Expanded(flex: 2, child: Text(l.equipment, style: style)),
          Expanded(flex: 3, child: Text(l.notes, style: style)),
        ],
      ]),
    );
  }
}

class _JumpRow extends StatelessWidget {
  final Jump jump;
  final AppLocalizations l;
  final DropZone? dz;
  final JumpType? jt;
  final Aircraft? aircraft;
  final Equipment? bag;
  final Equipment? canopy;
  final Equipment? suit;
  final String residenceCountry;
  final VoidCallback onUpdated;

  const _JumpRow({required this.jump, required this.l, this.dz, this.jt, this.aircraft, this.bag, this.canopy, this.suit, required this.residenceCountry, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMd(Localizations.localeOf(context).toString()).format(jump.date);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final dzName = dz?.name ?? '-';
    final dzCountry = dz?.country ?? '';
    final typeName = jt?.name ?? '';
    final aircraftName = aircraft?.name ?? '';
    final isForeign = residenceCountry.isNotEmpty && dzCountry.isNotEmpty &&
        dzCountry.toLowerCase() != residenceCountry.toLowerCase();
    final subtitleStyle = TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160));
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final equipLines = [bag?.name, canopy?.name, suit?.name].whereType<String>().toList();

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => JumpDetailScreen(jump: jump)),
      ).then((_) => onUpdated()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${jump.num}', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (jump.cutaway)
                  Icon(Icons.paragliding, size: 14, color: primaryColor),
              ],
            ),
          ),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(dzName, overflow: TextOverflow.ellipsis),
            if (dzCountry.isNotEmpty)
              Text(dzCountry, style: subtitleStyle.copyWith(color: isForeign ? primaryColor : null), overflow: TextOverflow.ellipsis),
          ])),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(dateStr, overflow: TextOverflow.ellipsis),
            if (typeName.isNotEmpty)
              Text(typeName, style: subtitleStyle, overflow: TextOverflow.ellipsis),
          ])),
          if (isLandscape) ...[
            Expanded(flex: 2, child: Text(aircraftName, overflow: TextOverflow.ellipsis, style: subtitleStyle.copyWith(fontSize: 13))),
            Expanded(flex: 2, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: equipLines.map((n) => Text(n, overflow: TextOverflow.ellipsis, style: subtitleStyle.copyWith(fontSize: 12))).toList(),
            )),
            Expanded(flex: 3, child: Text(jump.notes, overflow: TextOverflow.ellipsis, maxLines: 2, style: subtitleStyle.copyWith(fontSize: 12))),
          ],
        ]),
      ),
    );
  }
}

class _FilterBanner extends StatelessWidget {
  final AppLocalizations l;
  final VoidCallback onClear;
  const _FilterBanner({required this.l, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: primary.withAlpha(30),
      child: Row(
        children: [
          Icon(Icons.filter_alt, size: 16, color: primary),
          const SizedBox(width: 8),
          Expanded(child: Text(l.filtersActive, style: TextStyle(color: primary, fontSize: 12))),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: primary),
            onPressed: onClear,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends ConsumerStatefulWidget {
  final JumpFilter filter;
  const _FilterSheet({required this.filter});

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late TextEditingController _searchCtrl;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _cutawayOnly = false;
  int? _dzId;
  String? _country;
  int? _aircraftId;
  int? _typeId;

  @override
  void initState() {
    super.initState();
    final f = widget.filter;
    _searchCtrl = TextEditingController(text: f.searchText);
    _dateFrom = f.dateFrom;
    _dateTo = f.dateTo;
    _cutawayOnly = f.cutawayOnly;
    _dzId = f.dropZoneId;
    _country = f.country;
    _aircraftId = f.aircraftId;
    _typeId = f.jumpTypeId;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _dateFrom : _dateTo) ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  void _reset() {
    setState(() {
      _searchCtrl.clear();
      _dateFrom = null;
      _dateTo = null;
      _cutawayOnly = false;
      _dzId = null;
      _country = null;
      _aircraftId = null;
      _typeId = null;
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      JumpFilter(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        searchText: _searchCtrl.text.trim(),
        cutawayOnly: _cutawayOnly,
        dropZoneId: _dzId,
        country: (_country != null && _country!.isNotEmpty) ? _country : null,
        aircraftId: _aircraftId,
        jumpTypeId: _typeId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final dzList = ref.watch(dropZonesProvider).value ?? [];
    final jtList = ref.watch(jumpTypesProvider).value ?? [];
    final aircraftList = ref.watch(aircraftProvider).value ?? [];
    final countries = dzList.map((d) => d.country).where((c) => c.isNotEmpty).toSet().toList()..sort();

    final bgColor = ref.watch(settingsProvider).backgroundColor;
    final dropdownColor = HSLColor.fromColor(bgColor)
        .withLightness((HSLColor.fromColor(bgColor).lightness + 0.2).clamp(0.0, 1.0))
        .toColor();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.filterJumps, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.filterDateFrom),
                  subtitle: Text(_dateFrom == null ? '-' : DateFormat.yMd(Localizations.localeOf(context).toString()).format(_dateFrom!)),
                  onTap: () => _pickDate(isFrom: true),
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.filterDateTo),
                  subtitle: Text(_dateTo == null ? '-' : DateFormat.yMd(Localizations.localeOf(context).toString()).format(_dateTo!)),
                  onTap: () => _pickDate(isFrom: false),
                ),
              ),
            ]),
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(labelText: l.filterSearchNotes),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l.filterCutawayOnly),
              value: _cutawayOnly,
              onChanged: (v) => setState(() => _cutawayOnly = v ?? false),
            ),
            _FilterDropdown<DropZone, int>(
              label: l.dropZone,
              value: _dzId,
              items: dzList,
              getName: (e) => e.name,
              getValue: (e) => e.id!,
              onChanged: (v) => setState(() => _dzId = v),
              dropdownColor: dropdownColor,
            ),
            _FilterDropdown<String, String>(
              label: l.country,
              value: _country,
              items: countries,
              getName: (e) => e,
              getValue: (e) => e,
              onChanged: (v) => setState(() => _country = v),
              dropdownColor: dropdownColor,
            ),
            _FilterDropdown<Aircraft, int>(
              label: l.aircraft,
              value: _aircraftId,
              items: aircraftList,
              getName: (e) => e.name,
              getValue: (e) => e.id!,
              onChanged: (v) => setState(() => _aircraftId = v),
              dropdownColor: dropdownColor,
            ),
            _FilterDropdown<JumpType, int>(
              label: l.jumpType,
              value: _typeId,
              items: jtList,
              getName: (e) => e.name,
              getValue: (e) => e.id!,
              onChanged: (v) => setState(() => _typeId = v),
              dropdownColor: dropdownColor,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: Text(l.resetFilters),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _apply,
                    child: Text(l.applyFilters),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown<T, V> extends StatelessWidget {
  final String label;
  final V? value;
  final List<T> items;
  final String Function(T) getName;
  final V Function(T) getValue;
  final void Function(V?) onChanged;
  final Color dropdownColor;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.getName,
    required this.getValue,
    required this.onChanged,
    required this.dropdownColor,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue = items.any((e) => getValue(e) == value) ? value : null;
    final allNames = ['-', ...items.map(getName)];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField<V>(
        initialValue: currentValue,
        decoration: InputDecoration(labelText: label),
        dropdownColor: dropdownColor,
        selectedItemBuilder: (_) => allNames.map((name) => Text(name, overflow: TextOverflow.ellipsis)).toList(),
        items: [
          DropdownMenuItem<V>(value: null, child: const Text('-')),
          ...items.map((e) => DropdownMenuItem<V>(value: getValue(e), child: Text(getName(e), overflow: TextOverflow.ellipsis))),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
