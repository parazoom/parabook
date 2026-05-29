import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import '../../models/equipment.dart';
import '../../providers/providers.dart';
import 'equipment_form_screen.dart';

class EquipmentListScreen extends ConsumerWidget {
  const EquipmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(text: l.bags),
            Tab(text: l.canopies),
            Tab(text: l.suits),
          ]),
          Expanded(
            child: TabBarView(children: [
              _EquipmentTab(type: EquipmentType.bag, ref: ref),
              _EquipmentTab(type: EquipmentType.canopy, ref: ref),
              _EquipmentTab(type: EquipmentType.suit, ref: ref),
            ]),
          ),
        ],
      ),
    );
  }
}

class _EquipmentTab extends ConsumerWidget {
  final EquipmentType type;
  final WidgetRef ref;

  const _EquipmentTab({required this.type, required this.ref});

  FutureProvider<List<Equipment>> get _provider {
    switch (type) {
      case EquipmentType.bag: return bagsProvider;
      case EquipmentType.canopy: return canopiesProvider;
      case EquipmentType.suit: return suitsProvider;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(_provider);

    return Stack(
      children: [
        itemsAsync.when(
          data: (items) {
            final active = items.where((e) => !e.isArchived).toList();
            final archived = items.where((e) => e.isArchived).toList();
            final p = MediaQuery.of(context).padding;
            return ListView(
              padding: EdgeInsets.fromLTRB(8 + p.left, 8, 8 + p.right, 8),
              children: [
                if (active.isNotEmpty) ...[
                  _SubHeader(l.active),
                  ...active.map((e) => _EquipmentTile(e: e, provider: _provider)),
                ],
                if (archived.isNotEmpty) ...[
                  _SubHeader(l.archived),
                  ...archived.map((e) => _EquipmentTile(e: e, provider: _provider)),
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
            heroTag: 'add_${type.name}',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EquipmentFormScreen(type: type)),
            ).then((_) => ref.invalidate(_provider)),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _EquipmentTile extends ConsumerWidget {
  final Equipment e;
  final FutureProvider<List<Equipment>> provider;

  const _EquipmentTile({required this.e, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = e.reminderStatus == ReminderStatus.overdue;
    final isSoon = e.reminderStatus == ReminderStatus.soon;

    return Card(
      child: ListTile(
        title: Row(children: [
          Text(e.name),
          if (e.isDefault) ...[
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 14, color: Colors.amber),
          ],
          if (isOverdue) ...[
            const SizedBox(width: 8),
            const Icon(Icons.dangerous, size: 14, color: Colors.red),
          ] else if (isSoon) ...[
            const SizedBox(width: 8),
            const Icon(Icons.warning, size: 14, color: Colors.orange),
          ],
        ]),
        subtitle: Text(e.isArchived ? 'Archivé' : ''),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EquipmentFormScreen(type: e.type, edit: e)),
        ).then((_) => ref.invalidate(provider)),
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
