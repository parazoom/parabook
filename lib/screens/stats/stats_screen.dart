import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final barColor = settings.primaryColor;
    final bgColor = settings.secondaryColor;
    final residenceCountry = settings.residenceCountry;

    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l.byDropZone),
              Tab(text: l.byAircraft),
              Tab(text: l.byEquipment),
              Tab(text: l.byJumpType),
              Tab(text: l.byYear),
              Tab(text: l.byCountry),
            ],
          ),
          Expanded(
            child: TabBarView(children: [
              _StatsTab(
                future: ref.read(jumpsDaoProvider).groupByDropZone(),
                nameKey: 'name',
                barColor: barColor,
                bgColor: bgColor,
                showStar: true,
                countryKey: 'country',
                residenceCountry: residenceCountry,
              ),
              _StatsTab(
                future: ref.read(jumpsDaoProvider).groupByAircraft(),
                nameKey: 'name',
                barColor: barColor,
                bgColor: bgColor,
                showStar: true,
              ),
              _EquipmentStats(ref: ref, barColor: barColor, bgColor: bgColor),
              _StatsTab(
                future: ref.read(jumpsDaoProvider).groupByJumpType(),
                nameKey: 'name',
                barColor: barColor,
                bgColor: bgColor,
                showStar: true,
              ),
              _StatsTab(
                future: ref.read(jumpsDaoProvider).groupByYear(),
                nameKey: 'year',
                barColor: barColor,
                bgColor: bgColor,
              ),
              _StatsTab(
                future: ref.read(jumpsDaoProvider).groupByCountry(),
                nameKey: 'name',
                barColor: barColor,
                bgColor: bgColor,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> future;
  final String nameKey;
  final Color barColor;
  final Color bgColor;
  final bool showStar;
  final String? countryKey;
  final String? residenceCountry;

  const _StatsTab({
    required this.future,
    required this.nameKey,
    required this.barColor,
    required this.bgColor,
    this.showStar = false,
    this.countryKey,
    this.residenceCountry,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final rows = snap.data!;
        if (rows.isEmpty) return const Center(child: Text('-'));
        final max = rows.map((r) => r['count'] as int).reduce((a, b) => a > b ? a : b).toDouble();
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
          itemCount: rows.length,
          itemBuilder: (context, i) {
            return _StatRow(
              row: rows[i],
              nameKey: nameKey,
              max: max,
              barColor: barColor,
              bgColor: bgColor,
              showStar: showStar,
              countryKey: countryKey,
              residenceCountry: residenceCountry,
            );
          },
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final Map<String, dynamic> row;
  final String nameKey;
  final double max;
  final Color barColor;
  final Color bgColor;
  final bool showStar;
  final String? countryKey;
  final String? residenceCountry;

  const _StatRow({
    required this.row,
    required this.nameKey,
    required this.max,
    required this.barColor,
    required this.bgColor,
    this.showStar = false,
    this.countryKey,
    this.residenceCountry,
  });

  @override
  Widget build(BuildContext context) {
    final name = row[nameKey]?.toString() ?? '-';
    final count = row['count'] as int;
    final ratio = max > 0 ? count / max : 0.0;
    final isDefault = showStar && row['is_default'] == 1;
    final country = countryKey != null ? row[countryKey]?.toString() ?? '' : '';
    final showCountry = country.isNotEmpty;
    final isForeign = showCountry &&
        residenceCountry != null &&
        residenceCountry!.isNotEmpty &&
        country.toLowerCase() != residenceCountry!.toLowerCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(child: Text(name, overflow: TextOverflow.ellipsis)),
                      if (isDefault) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                      ],
                    ]),
                    if (showCountry)
                      Text(
                        country,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 11,
                          color: isForeign ? Colors.red : null,
                        ),
                      ),
                  ],
                ),
              ),
              Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
            color: barColor,
            backgroundColor: bgColor,
          ),
        ],
      ),
    );
  }
}

class _EquipmentStats extends StatelessWidget {
  final WidgetRef ref;
  final Color barColor;
  final Color bgColor;
  const _EquipmentStats({required this.ref, required this.barColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
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
              _EquipmentStatsSubTab(future: ref.read(jumpsDaoProvider).groupByEquipment('bag'), barColor: barColor, bgColor: bgColor),
              _EquipmentStatsSubTab(future: ref.read(jumpsDaoProvider).groupByEquipment('canopy'), barColor: barColor, bgColor: bgColor),
              _EquipmentStatsSubTab(future: ref.read(jumpsDaoProvider).groupByEquipment('suit'), barColor: barColor, bgColor: bgColor),
            ]),
          ),
        ],
      ),
    );
  }
}

class _EquipmentStatsSubTab extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> future;
  final Color barColor;
  final Color bgColor;
  const _EquipmentStatsSubTab({required this.future, required this.barColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: future,
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final rows = snap.data!;
        if (rows.isEmpty) return const Center(child: Text('-'));
        final active = rows.where((r) => r['is_archived'] == 0).toList();
        final archived = rows.where((r) => r['is_archived'] == 1).toList();
        final max = rows.map((r) => r['count'] as int).reduce((a, b) => a > b ? a : b).toDouble();
        return ListView(
          padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
          children: [
            if (active.isNotEmpty) ...[
              _StatsSubHeader(l.active),
              ...active.map((r) => _StatRow(row: r, nameKey: 'name', max: max, barColor: barColor, bgColor: bgColor, showStar: true)),
            ],
            if (archived.isNotEmpty) ...[
              _StatsSubHeader(l.archived),
              ...archived.map((r) => _StatRow(row: r, nameKey: 'name', max: max, barColor: barColor, bgColor: bgColor, showStar: true)),
            ],
          ],
        );
      },
    );
  }
}

class _StatsSubHeader extends StatelessWidget {
  final String title;
  const _StatsSubHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
