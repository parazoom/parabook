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
    final rows = await ref.read(jumpsDaoProvider).getPage(_pageSize, beforeNum: _lastNum);
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
        if (_jumps.isEmpty && _loading)
          const Center(child: CircularProgressIndicator())
        else if (_jumps.isEmpty)
          Center(child: Text(l.noJumps))
        else
          _JumpsList(jumps: _jumps, l: l, scrollCtrl: _scrollCtrl, loading: _loading, onUpdated: _refresh),
        Positioned(
          bottom: 24 + MediaQuery.of(context).padding.bottom,
          right: 16 + MediaQuery.of(context).padding.right,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
