import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';
import '../../models/equipment.dart';
import '../../models/useful_link.dart';
import '../jumps/add_jump_screen.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final summary = ref.watch(summaryProvider);
    final reminders = ref.watch(activeRemindersProvider);
    final settings = ref.watch(settingsProvider);
    final links = ref.watch(usefulLinksProvider);

    final sysPad = MediaQuery.of(context).padding;
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(16 + sysPad.left, 16, 16 + sysPad.right, 16),
          children: [
            reminders.when(
              data: (items) {
                if (items.isEmpty) return const SizedBox.shrink();
                return Column(
                  children: items.map((e) => _ReminderBanner(equipment: e)).toList(),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            summary.when(
              data: (data) => _SummaryCards(data: data, l: l, jumpsBefore: settings.jumpsBefore, licenseNumber: settings.licenseNumber, skydiversInfo: settings.skydiversInfo, links: links.valueOrNull ?? []),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur: $e')),
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
                heroTag: 'copy_last',
                onPressed: () => _copyLast(context, ref),
                child: const Icon(Icons.copy),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'add_jump',
                onPressed: () => _addJump(context),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addJump(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddJumpScreen()));
  }

  Future<void> _copyLast(BuildContext context, WidgetRef ref) async {
    final last = await ref.read(jumpsDaoProvider).getLast();
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddJumpScreen(copyFrom: last)),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final Map<String, dynamic> data;
  final AppLocalizations l;
  final int jumpsBefore;
  final String licenseNumber;
  final String skydiversInfo;
  final List<UsefulLink> links;

  const _SummaryCards({required this.data, required this.l, required this.jumpsBefore, required this.licenseNumber, required this.skydiversInfo, required this.links});

  @override
  Widget build(BuildContext context) {
    final lastJump = data['lastJump'];
    final lastDate = lastJump != null
        ? DateFormat.yMd(Localizations.localeOf(context).toString()).format(lastJump.date)
        : '-';
    final cutawayCount = data['cutaways'] as int;
    final dzCount = data['dzCount'] as int;

    return Column(
      children: [
        _BigStat(label: l.totalJumps, value: '${data['total'] + jumpsBefore}'),
        if (jumpsBefore > 0) ...[
          const SizedBox(height: 4),
          Text(
            'dont $jumpsBefore avant l\'application',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _StatCard(label: cutawayCount == 1 ? 'Libé' : 'Libés', value: '$cutawayCount')),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'DZ', value: '$dzCount')),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: l.countries, value: '${data['countryCount']}')),
        ]),
        const SizedBox(height: 12),
        _StatCard(label: l.lastJump, value: lastDate, fullWidth: true),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _StatCard(label: l.last30Days, value: '${data['last30']}')),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: l.last12Months, value: '${data['last12m']}')),
        ]),
        if (licenseNumber.isNotEmpty || skydiversInfo.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SkydiversCard(licenseNumber: licenseNumber, info: skydiversInfo),
        ],
        if (links.isNotEmpty) ...[
          const SizedBox(height: 12),
          _UsefulLinksButtons(links: links),
        ],
        SizedBox(height: 100 + MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}

class _BigStat extends StatelessWidget {
  final String label;
  final String value;
  const _BigStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: primary)),
          Text(label, style: Theme.of(context).textTheme.titleLarge),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool fullWidth;
  const _StatCard({required this.label, required this.value, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _SkydiversCard extends StatelessWidget {
  final String licenseNumber;
  final String info;
  const _SkydiversCard({required this.licenseNumber, required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (licenseNumber.isNotEmpty) ...[
              Row(children: [
                Icon(Icons.badge, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(licenseNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ],
            if (licenseNumber.isNotEmpty && info.isNotEmpty) const SizedBox(height: 6),
            if (info.isNotEmpty)
              Text(info, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _UsefulLinksButtons extends StatelessWidget {
  final List<UsefulLink> links;
  const _UsefulLinksButtons({required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: links.map((link) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OutlinedButton.icon(
          icon: const Icon(Icons.open_in_new, size: 16),
          label: Text(link.title),
          onPressed: () async {
            final uri = Uri.tryParse(link.url);
            if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
        ),
      )).toList(),
    );
  }
}

class _ReminderBanner extends StatelessWidget {
  final Equipment equipment;
  const _ReminderBanner({required this.equipment});

  @override
  Widget build(BuildContext context) {
    final isOverdue = equipment.reminderStatus == ReminderStatus.overdue;
    final color = isOverdue ? Colors.red : Colors.orange;
    final dateStr = equipment.reminderDate != null
        ? DateFormat.yMd(Localizations.localeOf(context).toString()).format(equipment.reminderDate!)
        : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(children: [
        Icon(isOverdue ? Icons.dangerous : Icons.warning, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(equipment.name, style: TextStyle(color: color)),
              if (dateStr.isNotEmpty)
                Text(dateStr, style: TextStyle(fontSize: 11, color: color)),
            ],
          ),
        ),
      ]),
    );
  }
}
