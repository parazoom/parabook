import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../models/equipment.dart';
import '../../providers/providers.dart';

class EquipmentFormScreen extends ConsumerStatefulWidget {
  final EquipmentType type;
  final Equipment? edit;

  const EquipmentFormScreen({super.key, required this.type, this.edit});

  @override
  ConsumerState<EquipmentFormScreen> createState() => _EquipmentFormScreenState();
}

class _EquipmentFormScreenState extends ConsumerState<EquipmentFormScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _jumpsBeforeCtrl;
  bool _isDefault = false;
  bool _isArchived = false;
  DateTime? _reminderDate;

  @override
  void initState() {
    super.initState();
    final e = widget.edit;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
    _jumpsBeforeCtrl = TextEditingController(text: '${e?.jumpsBefore ?? 0}');
    _isDefault = e?.isDefault ?? false;
    _isArchived = e?.isArchived ?? false;
    _reminderDate = e?.reminderDate;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    _jumpsBeforeCtrl.dispose();
    super.dispose();
  }

  String _typeLabel(AppLocalizations l) {
    switch (widget.type) {
      case EquipmentType.bag: return l.bag;
      case EquipmentType.canopy: return l.canopy;
      case EquipmentType.suit: return l.suit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isEdit = widget.edit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('${isEdit ? l.save : l.addEquipment} — ${_typeLabel(l)}'),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _delete(context, l),
                )
              ]
            : null,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
        children: [
          TextField(controller: _nameCtrl, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: l.name)),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.isDefault),
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v ?? false),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.isArchived),
            value: _isArchived,
            onChanged: (v) => setState(() => _isArchived = v ?? false),
          ),
          TextField(
            controller: _jumpsBeforeCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l.jumpsBefore),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.reminderDate),
            subtitle: _reminderDate != null
                ? Text(DateFormat.yMd(Localizations.localeOf(context).toString()).format(_reminderDate!))
                : null,
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (_reminderDate != null)
                IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _reminderDate = null)),
              const Icon(Icons.calendar_today),
            ]),
            onTap: _pickDate,
          ),
          const Divider(),
          TextField(
            controller: _notesCtrl,
            maxLines: 3,
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
      initialDate: _reminderDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _reminderDate = picked);
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    final dao = ref.read(equipmentDaoProvider);
    final e = Equipment(
      id: widget.edit?.id,
      name: _nameCtrl.text.trim(),
      type: widget.type,
      isDefault: _isDefault,
      isArchived: _isArchived,
      jumpsBefore: int.tryParse(_jumpsBeforeCtrl.text) ?? 0,
      reminderDate: _reminderDate,
      notes: _notesCtrl.text,
    );
    if (widget.edit != null) {
      await dao.update(e);
    } else {
      await dao.insert(e);
    }
    ref.invalidate(bagsProvider);
    ref.invalidate(canopiesProvider);
    ref.invalidate(suitsProvider);
    ref.invalidate(activeRemindersProvider);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context, AppLocalizations l) async {
    final nav = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.confirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.no)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.yes)),
        ],
      ),
    );
    if (ok == true && widget.edit?.id != null) {
      await ref.read(equipmentDaoProvider).delete(widget.edit!.id!);
      ref.invalidate(bagsProvider);
      ref.invalidate(canopiesProvider);
      ref.invalidate(suitsProvider);
      if (mounted) nav.pop();
    }
  }
}
