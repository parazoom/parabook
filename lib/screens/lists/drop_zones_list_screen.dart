import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import '../../models/drop_zone.dart';
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';

class DropZonesListScreen extends ConsumerWidget {
  const DropZonesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final dzAsync = ref.watch(dropZonesProvider);
    final residenceCountry = ref.watch(settingsProvider).residenceCountry;

    return Stack(
      children: [
        dzAsync.when(
          data: (items) {
            final active = items.where((e) => !e.isArchived).toList();
            final archived = items.where((e) => e.isArchived).toList();
            final p = MediaQuery.of(context).padding;
            return ListView(
              padding: EdgeInsets.fromLTRB(8 + p.left, 8, 8 + p.right, 8),
              children: [
                if (active.isNotEmpty) ...[
                  _SubHeader(l.active),
                  ...active.map((dz) => _DZTile(dz: dz, residenceCountry: residenceCountry, l: l, ref: ref)),
                ],
                if (archived.isNotEmpty) ...[
                  _SubHeader(l.archived),
                  ...archived.map((dz) => _DZTile(dz: dz, residenceCountry: residenceCountry, l: l, ref: ref)),
                ],
                const SizedBox(height: 80),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
        Positioned(
          bottom: 16 + MediaQuery.of(context).padding.bottom,
          right: 16 + MediaQuery.of(context).padding.right,
          child: FloatingActionButton(
            heroTag: 'add_dz',
            onPressed: () => _showForm(context, ref, l, null),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, AppLocalizations l, DropZone? dz) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DZForm(dz: dz, ref: ref, l: l),
    ).then((_) => ref.invalidate(dropZonesProvider));
  }
}

class _DZTile extends StatelessWidget {
  final DropZone dz;
  final String residenceCountry;
  final AppLocalizations l;
  final WidgetRef ref;

  const _DZTile({required this.dz, required this.residenceCountry, required this.l, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isForeign = dz.country.isNotEmpty &&
        residenceCountry.isNotEmpty &&
        dz.country.toLowerCase() != residenceCountry.toLowerCase();
    return Card(
      child: ListTile(
        title: Row(children: [
          Flexible(child: Text(dz.name, overflow: TextOverflow.ellipsis)),
          if (dz.isDefault) ...[
            const SizedBox(width: 6),
            const Icon(Icons.star, size: 14, color: Colors.amber),
          ],
          if (dz.country.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              dz.country,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: isForeign ? Colors.red : null,
              ),
            ),
          ],
        ]),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _DZForm(dz: dz, ref: ref, l: l),
          ).then((_) => ref.invalidate(dropZonesProvider));
        },
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  final String title;
  const _SubHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Text(title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1,
          )),
    );
  }
}

class _DZForm extends ConsumerStatefulWidget {
  final DropZone? dz;
  final WidgetRef ref;
  final AppLocalizations l;

  const _DZForm({required this.dz, required this.ref, required this.l});

  @override
  ConsumerState<_DZForm> createState() => _DZFormState();
}

class _DZFormState extends ConsumerState<_DZForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _jumpsBeforeCtrl;
  bool _isDefault = false;
  bool _isArchived = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.dz?.name ?? '');
    _countryCtrl = TextEditingController(text: widget.dz?.country ?? '');
    _notesCtrl = TextEditingController(text: widget.dz?.notes ?? '');
    _jumpsBeforeCtrl = TextEditingController(text: '${widget.dz?.jumpsBefore ?? 0}');
    _isDefault = widget.dz?.isDefault ?? false;
    _isArchived = widget.dz?.isArchived ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _countryCtrl.dispose();
    _notesCtrl.dispose();
    _jumpsBeforeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).viewPadding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.dz != null ? l.dropZone : l.addDropZone,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          TextField(controller: _nameCtrl, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: l.name)),
          TextField(controller: _countryCtrl, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: l.country)),
          TextField(
            controller: _jumpsBeforeCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l.jumpsBefore),
          ),
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
          TextField(controller: _notesCtrl, textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(labelText: l.notes), maxLines: 2),
          const SizedBox(height: 12),
          Row(children: [
            if (widget.dz != null)
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: Text(l.delete, style: const TextStyle(color: Colors.red)),
                onPressed: () => _delete(context),
              ),
            const Spacer(),
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _save, child: Text(l.save)),
          ]),
        ],
      ),
    ));
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    final dao = ref.read(dropZonesDaoProvider);
    final dz = DropZone(
      id: widget.dz?.id,
      name: _nameCtrl.text.trim(),
      country: _countryCtrl.text.trim(),
      isDefault: _isDefault,
      isArchived: _isArchived,
      jumpsBefore: int.tryParse(_jumpsBeforeCtrl.text) ?? 0,
      notes: _notesCtrl.text,
    );
    if (widget.dz != null) {
      await dao.update(dz);
    } else {
      await dao.insert(dz);
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context) async {
    final nav = Navigator.of(context);
    if (widget.dz?.id != null) {
      await ref.read(dropZonesDaoProvider).delete(widget.dz!.id!);
    }
    if (mounted) nav.pop();
  }
}
