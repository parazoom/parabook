import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/useful_link.dart';
import '../../providers/providers.dart';

class UsefulLinksScreen extends ConsumerWidget {
  const UsefulLinksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksAsync = ref.watch(usefulLinksProvider);

    return Stack(
      children: [
        linksAsync.when(
          data: (items) => ListView.builder(
            padding: EdgeInsets.fromLTRB(8 + MediaQuery.of(context).padding.left, 8, 8 + MediaQuery.of(context).padding.right, 8),
            itemCount: items.length + 1,
            itemBuilder: (context, i) {
              if (i == items.length) return const SizedBox(height: 80);
              final link = items[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(link.title),
                  subtitle: Text(link.url, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12)),
                  onTap: () => _showForm(context, ref, link),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
        Positioned(
          bottom: 16 + MediaQuery.of(context).padding.bottom,
          right: 16 + MediaQuery.of(context).padding.right,
          child: FloatingActionButton(
            heroTag: 'add_link',
            onPressed: () => _showForm(context, ref, null),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, UsefulLink? link) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _LinkForm(link: link, ref: ref),
    ).then((_) => ref.invalidate(usefulLinksProvider));
  }
}

class _LinkForm extends ConsumerStatefulWidget {
  final UsefulLink? link;
  final WidgetRef ref;
  const _LinkForm({required this.link, required this.ref});

  @override
  ConsumerState<_LinkForm> createState() => _LinkFormState();
}

class _LinkFormState extends ConsumerState<_LinkForm> {
  late TextEditingController _titleCtrl;
  late TextEditingController _urlCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.link?.title ?? '');
    _urlCtrl = TextEditingController(text: widget.link?.url ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Text(widget.link != null ? 'Lien utile' : 'Ajouter un lien',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: _titleCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Titre'),
          ),
          TextField(
            controller: _urlCtrl,
            keyboardType: TextInputType.url,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Lien (URL)'),
          ),
          const SizedBox(height: 12),
          Row(children: [
            if (widget.link != null)
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                onPressed: () => _delete(context),
              ),
            const Spacer(),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _save, child: const Text('Enregistrer')),
          ]),
        ],
      ),
    ));
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty || _urlCtrl.text.trim().isEmpty) return;
    final dao = ref.read(usefulLinksDaoProvider);
    final link = UsefulLink(
      id: widget.link?.id,
      title: _titleCtrl.text.trim(),
      url: _urlCtrl.text.trim(),
    );
    if (widget.link != null) {
      await dao.update(link);
    } else {
      await dao.insert(link);
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context) async {
    final nav = Navigator.of(context);
    if (widget.link?.id != null) {
      await ref.read(usefulLinksDaoProvider).delete(widget.link!.id!);
    }
    if (mounted) nav.pop();
  }
}
