import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import '../../models/jump_type.dart';
import '../../providers/providers.dart';

class JumpTypesListScreen extends ConsumerWidget {
  const JumpTypesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(jumpTypesProvider);

    return Stack(
      children: [
        async.when(
          data: (items) {
            final active = items.where((e) => !e.isArchived).toList();
            final archived = items.where((e) => e.isArchived).toList();
            final p = MediaQuery.of(context).padding;
            return ListView(
              padding: EdgeInsets.fromLTRB(8 + p.left, 8, 8 + p.right, 8),
              children: [
                if (active.isNotEmpty) ...[
                  _SubHeader(l.active),
                  ...active.map((jt) => _JTTile(jt: jt, l: l, ref: ref)),
                ],
                if (archived.isNotEmpty) ...[
                  _SubHeader(l.archived),
                  ...archived.map((jt) => _JTTile(jt: jt, l: l, ref: ref)),
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
            heroTag: 'add_jt',
            onPressed: () => _showForm(context, ref, l, null),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, AppLocalizations l, JumpType? jt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _JTForm(jt: jt, ref: ref, l: l),
    ).then((_) => ref.invalidate(jumpTypesProvider));
  }
}

class _JTTile extends StatelessWidget {
  final JumpType jt;
  final AppLocalizations l;
  final WidgetRef ref;

  const _JTTile({required this.jt, required this.l, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(children: [
          Text(jt.name),
          if (jt.isDefault) ...[
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 14, color: Colors.amber),
          ],
        ]),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _JTForm(jt: jt, ref: ref, l: l),
          ).then((_) => ref.invalidate(jumpTypesProvider));
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

class _JTForm extends ConsumerStatefulWidget {
  final JumpType? jt;
  final WidgetRef ref;
  final AppLocalizations l;

  const _JTForm({required this.jt, required this.ref, required this.l});

  @override
  ConsumerState<_JTForm> createState() => _JTFormState();
}

class _JTFormState extends ConsumerState<_JTForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _jumpsBeforeCtrl;
  bool _isDefault = false;
  bool _isArchived = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.jt?.name ?? '');
    _notesCtrl = TextEditingController(text: widget.jt?.notes ?? '');
    _jumpsBeforeCtrl = TextEditingController(text: '${widget.jt?.jumpsBefore ?? 0}');
    _isDefault = widget.jt?.isDefault ?? false;
    _isArchived = widget.jt?.isArchived ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
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
          Text(widget.jt != null ? widget.jt!.name : l.addJumpType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          TextField(controller: _nameCtrl, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: l.name)),
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
            if (widget.jt != null)
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: Text(l.delete, style: const TextStyle(color: Colors.red)),
                onPressed: () async {
                  final nav = Navigator.of(context);
                  if (widget.jt?.id != null) await ref.read(jumpTypesDaoProvider).delete(widget.jt!.id!);
                  if (mounted) nav.pop();
                },
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
    final jt = JumpType(
      id: widget.jt?.id,
      name: _nameCtrl.text.trim(),
      isDefault: _isDefault,
      isArchived: _isArchived,
      jumpsBefore: int.tryParse(_jumpsBeforeCtrl.text) ?? 0,
      notes: _notesCtrl.text,
    );
    if (widget.jt != null) {
      await ref.read(jumpTypesDaoProvider).update(jt);
    } else {
      await ref.read(jumpTypesDaoProvider).insert(jt);
    }
    if (mounted) Navigator.pop(context);
  }
}
