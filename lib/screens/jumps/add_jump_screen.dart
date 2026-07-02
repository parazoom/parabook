import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../models/jump.dart';
import '../../models/drop_zone.dart';
import '../../models/equipment.dart';
import '../../models/jump_type.dart';
import '../../models/aircraft.dart';
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';

class AddJumpScreen extends ConsumerStatefulWidget {
  final Jump? copyFrom;
  final Jump? editJump;

  const AddJumpScreen({super.key, this.copyFrom, this.editJump});

  @override
  ConsumerState<AddJumpScreen> createState() => _AddJumpScreenState();
}

class _AddJumpScreenState extends ConsumerState<AddJumpScreen> {
  late TextEditingController _numCtrl;
  late TextEditingController _notesCtrl;
  DateTime _date = DateTime.now();
  int? _dzId, _aircraftId, _bagId, _canopyId, _suitId, _typeId;
  bool _cutaway = false;
  bool _loading = true;
  String? _numError;

  @override
  void initState() {
    super.initState();
    _numCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
    _init();
  }

  Future<void> _init() async {
    final dao = ref.read(jumpsDaoProvider);
    final j = widget.editJump ?? widget.copyFrom;

    if (j != null) {
      _numCtrl.text = widget.editJump != null
          ? '${j.num}'
          : '${(j.num) + 1}';
      _date = j.date;
      _dzId = j.dropZoneId;
      _aircraftId = j.aircraftId;
      _bagId = j.bagId;
      _canopyId = j.canopyId;
      _suitId = j.suitId;
      _typeId = j.jumpTypeId;
      _cutaway = widget.editJump != null ? j.cutaway : false;
      _notesCtrl.text = widget.editJump != null ? j.notes : '';
    } else {
      final nextNum = await dao.getNextNum();
      _numCtrl.text = '$nextNum';

      final dzDao = ref.read(dropZonesDaoProvider);
      final eqDao = ref.read(equipmentDaoProvider);
      final jtDao = ref.read(jumpTypesDaoProvider);
      final acDao = ref.read(aircraftDaoProvider);

      final dz = await dzDao.getDefault();
      final bag = await eqDao.getDefault(EquipmentType.bag);
      final canopy = await eqDao.getDefault(EquipmentType.canopy);
      final suit = await eqDao.getDefault(EquipmentType.suit);
      final jt = await jtDao.getDefault();
      final ac = await acDao.getDefault();

      _dzId = dz?.id;
      _bagId = bag?.id;
      _canopyId = canopy?.id;
      _suitId = suit?.id;
      _typeId = jt?.id;
      _aircraftId = ac?.id;
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _numCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final dzsAsync = ref.watch(dropZonesProvider);
    final jtAsync = ref.watch(jumpTypesProvider);
    final acAsync = ref.watch(aircraftProvider);
    final bagsAsync = ref.watch(bagsProvider);
    final canopiesAsync = ref.watch(canopiesProvider);
    final suitsAsync = ref.watch(suitsProvider);

    final isEdit = widget.editJump != null;
    final bgColor = ref.watch(settingsProvider).backgroundColor;
    final dropdownColor = HSLColor.fromColor(bgColor)
        .withLightness((HSLColor.fromColor(bgColor).lightness + 0.2).clamp(0.0, 1.0))
        .toColor();

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? l.editJump : l.addJump)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
              children: [
                TextField(
                  controller: _numCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.jumpNumber, errorText: _numError),
                  onChanged: (_) {
                    if (_numError != null) setState(() => _numError = null);
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.date),
                  subtitle: Text(DateFormat.yMd(Localizations.localeOf(context).toString()).format(_date)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
                const Divider(),
                _DropdownField<DropZone>(
                  label: l.dropZone,
                  value: _dzId,
                  items: (dzsAsync.value ?? []).where((e) => !e.isArchived).toList(),
                  getName: (e) => e.name,
                  getId: (e) => e.id!,
                  onChanged: (v) => setState(() => _dzId = v),
                  dropdownColor: dropdownColor,
                ),
                _DropdownField<Aircraft>(
                  label: l.aircraft,
                  value: _aircraftId,
                  items: (acAsync.value ?? []).where((e) => !e.isArchived).toList(),
                  getName: (e) => e.name,
                  getId: (e) => e.id!,
                  onChanged: (v) => setState(() => _aircraftId = v),
                  dropdownColor: dropdownColor,
                ),
                _DropdownField<Equipment>(
                  label: l.canopy,
                  value: _canopyId,
                  items: (canopiesAsync.value ?? []).where((e) => !e.isArchived).toList(),
                  getName: (e) => e.name,
                  getId: (e) => e.id!,
                  onChanged: (v) => setState(() => _canopyId = v),
                  dropdownColor: dropdownColor,
                ),
                _DropdownField<Equipment>(
                  label: l.bag,
                  value: _bagId,
                  items: (bagsAsync.value ?? []).where((e) => !e.isArchived).toList(),
                  getName: (e) => e.name,
                  getId: (e) => e.id!,
                  onChanged: (v) => setState(() => _bagId = v),
                  dropdownColor: dropdownColor,
                ),
                _DropdownField<Equipment>(
                  label: l.suit,
                  value: _suitId,
                  items: (suitsAsync.value ?? []).where((e) => !e.isArchived).toList(),
                  getName: (e) => e.name,
                  getId: (e) => e.id!,
                  onChanged: (v) => setState(() => _suitId = v),
                  dropdownColor: dropdownColor,
                ),
                _DropdownField<JumpType>(
                  label: l.jumpType,
                  value: _typeId,
                  items: (jtAsync.value ?? []).where((e) => !e.isArchived).toList(),
                  getName: (e) => e.name,
                  getId: (e) => e.id!,
                  onChanged: (v) => setState(() => _typeId = v),
                  dropdownColor: dropdownColor,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.cutaway),
                  value: _cutaway,
                  onChanged: (v) => setState(() => _cutaway = v),
                ),
                const Divider(),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: l.notes),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _save,
                  child: Text(l.save),
                ),
              ],
            ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final num = int.tryParse(_numCtrl.text);
    if (num == null) return;

    final dao = ref.read(jumpsDaoProvider);
    final exists = await dao.numExists(num, excludeId: widget.editJump?.id);
    if (exists) {
      setState(() => _numError = l.jumpNumberExists);
      return;
    }

    final jump = Jump(
      id: widget.editJump?.id,
      num: num,
      date: _date,
      jumpTypeId: _typeId,
      dropZoneId: _dzId,
      aircraftId: _aircraftId,
      bagId: _bagId,
      canopyId: _canopyId,
      suitId: _suitId,
      cutaway: _cutaway,
      notes: _notesCtrl.text,
    );

    if (widget.editJump != null) {
      await dao.update(jump);
    } else {
      await dao.insert(jump);
    }

    ref.invalidate(jumpsProvider);
    ref.invalidate(summaryProvider);

    if (mounted) Navigator.pop(context);
  }
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final int? value;
  final List<T> items;
  final String Function(T) getName;
  final int Function(T) getId;
  final void Function(int?) onChanged;
  final Color dropdownColor;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.getName,
    required this.getId,
    required this.onChanged,
    required this.dropdownColor,
  });

  Widget _item(String name, bool selected, Color primary) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: 24,
        child: selected
            ? Icon(Icons.check_box, size: 18, color: primary)
            : const Icon(Icons.check_box_outline_blank, size: 18),
      ),
      const SizedBox(width: 8),
      Text(name),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final currentValue = items.any((e) => getId(e) == value) ? value : null;

    final allNames = ['-', ...items.map(getName)];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<int>(
        initialValue: currentValue,
        decoration: InputDecoration(labelText: label),
        dropdownColor: dropdownColor,
        selectedItemBuilder: (_) => allNames.map((name) => Text(name, overflow: TextOverflow.ellipsis)).toList(),
        items: [
          DropdownMenuItem(value: null, child: _item('-', currentValue == null, primary)),
          ...items.map((e) => DropdownMenuItem(
              value: getId(e),
              child: _item(getName(e), getId(e) == currentValue, primary))),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
