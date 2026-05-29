import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../models/jump.dart';
import '../../providers/providers.dart';
import 'add_jump_screen.dart';

class JumpDetailScreen extends ConsumerWidget {
  final Jump jump;
  const JumpDetailScreen({super.key, required this.jump});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final dz = ref.watch(dropZonesProvider).value?.where((d) => d.id == jump.dropZoneId).firstOrNull;
    final jt = ref.watch(jumpTypesProvider).value?.where((t) => t.id == jump.jumpTypeId).firstOrNull;
    final ac = ref.watch(aircraftProvider).value?.where((a) => a.id == jump.aircraftId).firstOrNull;
    final bag = ref.watch(bagsProvider).value?.where((e) => e.id == jump.bagId).firstOrNull;
    final canopy = ref.watch(canopiesProvider).value?.where((e) => e.id == jump.canopyId).firstOrNull;
    final suit = ref.watch(suitsProvider).value?.where((e) => e.id == jump.suitId).firstOrNull;

    final dateStr = DateFormat.yMd(Localizations.localeOf(context).toString()).format(jump.date);

    return Scaffold(
      appBar: AppBar(
        title: Text('${l.jumpNumber}${jump.num}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AddJumpScreen(editJump: jump)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref, l),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
        children: [
          _DetailRow(l.date, dateStr),
          _DetailRow(l.dropZone, dz?.name ?? '-'),
          _DetailRow(l.country, dz?.country ?? '-'),
          _DetailRow(l.aircraft, ac?.name ?? '-'),
          _DetailRow(l.jumpType, jt?.name ?? '-'),
          _DetailRow(l.canopy, canopy?.name ?? '-'),
          _DetailRow(l.bag, bag?.name ?? '-'),
          _DetailRow(l.suit, suit?.name ?? '-'),
          _DetailRow(l.cutaway, jump.cutaway ? '✓' : '-'),
          if (jump.notes.isNotEmpty) ...[
            const Divider(),
            Text(l.notes, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(jump.notes),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, AppLocalizations l) async {
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
    if (ok == true && jump.id != null) {
      await ref.read(jumpsDaoProvider).delete(jump.id!);
      ref.invalidate(jumpsProvider);
      ref.invalidate(summaryProvider);
      if (context.mounted) Navigator.pop(context);
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
