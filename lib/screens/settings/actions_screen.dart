import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'dart:typed_data';
// Implémentation choisie à la compilation : navigateur (web) ou natif (mobile/desktop).
import '../../utils/csv_io_native.dart' if (dart.library.js_interop) '../../utils/csv_io_web.dart' as csvio;
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';
import '../../db/database.dart';
import 'settings_screen.dart';
import 'skydivers_settings_screen.dart';
import 'info_help_screen.dart';

class ActionsScreen extends ConsumerWidget {
  const ActionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return ListView(
      padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
      children: [
        _SectionTitle(l.import),
        Card(
          child: ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(l.importCsv),
            onTap: () => _importCsv(context, ref),
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle(l.export),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(l.exportShare),
              onTap: () => _exportShare(context, ref),
            ),
            Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: Text(l.exportFile),
              onTap: () => _exportFile(context, ref),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        _SectionTitle(l.settings),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres application'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Paramètres parachutiste'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkydiversSettingsScreen()),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Info & Aide'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InfoHelpScreen()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text(l.contactDeveloper),
            onTap: () => _contactDev(context, ref),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            'ParaBook v1.0.0',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<String> _buildCsv(WidgetRef ref) async {
    final db = await AppDatabase.instance;
    final rows = await db.rawQuery('''
      SELECT j.num, j.date, jt.name as type, dz.name as dz, dz.country,
             a.name as aircraft, bag.name as bag, can.name as canopy,
             suit.name as suit, j.cutaway, j.notes
      FROM jumps j
      LEFT JOIN jump_types jt ON j.jump_type_id = jt.id
      LEFT JOIN drop_zones dz ON j.drop_zone_id = dz.id
      LEFT JOIN aircraft a ON j.aircraft_id = a.id
      LEFT JOIN equipment bag ON j.bag_id = bag.id
      LEFT JOIN equipment can ON j.canopy_id = can.id
      LEFT JOIN equipment suit ON j.suit_id = suit.id
      ORDER BY j.num ASC
    ''');

    const converter = ListToCsvConverter();
    final data = [
      ['num', 'date', 'type', 'dz', 'country', 'plane', 'bag', 'canopy', 'suit', 'cut away', 'notes'],
      ...rows.map((r) => [
        r['num'], r['date'], r['type'] ?? '', r['dz'] ?? '', r['country'] ?? '',
        r['aircraft'] ?? '', r['bag'] ?? '', r['canopy'] ?? '', r['suit'] ?? '',
        r['cutaway'] == 1 ? 'Oui' : 'Non', r['notes'] ?? '',
      ]),
    ];
    return converter.convert(data);
  }

  Future<void> _exportShare(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final csv = await _buildCsv(ref);
    final bytes = Uint8List.fromList(utf8.encode(csv));
    // Natif : feuille de partage système. Web : API Web Share (repli téléchargement).
    await csvio.shareCsv(
      _exportFileName(),
      bytes,
      subject: l.exportEmailSubject,
      text: l.exportEmailBody,
    );
  }

  Future<void> _exportFile(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final csv = await _buildCsv(ref);
    final bytes = Uint8List.fromList(utf8.encode(csv));
    // Natif : sélecteur système (→ Téléchargements). Web : téléchargement navigateur.
    final path = await csvio.saveCsv(_exportFileName(), bytes, dialogTitle: l.exportFile);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(path == null ? l.exportCancelled : l.exportSaved(path))),
    );
  }

  String _exportFileName() {
    final now = DateTime.now();
    final d = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return 'parabook_export_$d.csv';
  }

  Future<void> _importCsv(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
      withData: true, // bytes disponibles sur toutes les plateformes (dont le web)
    );
    if (result == null || result.files.single.bytes == null) return;

    final content = utf8.decode(result.files.single.bytes!, allowMalformed: true);
    final delimiter = _detectDelimiter(content);
    final rows = CsvToListConverter(
      fieldDelimiter: delimiter,
      shouldParseNumbers: false,
    ).convert(content);

    final issues = _checkCsvFormat(rows, delimiter);
    if (issues.isNotEmpty) {
      if (!context.mounted) return;
      final proceed = await _showFormatIssuesDialog(context, issues, rows);
      if (proceed != true) return;
    }

    int skipped = 0;
    final db = await AppDatabase.instance;
    final total = rows.length - 1;
    final progress = ValueNotifier<double>(0.0);

    if (!context.mounted) return;
    final settings = ref.read(settingsProvider);
    final barColor = settings.primaryColor;
    final bgColor = settings.secondaryColor;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Import en cours…'),
          content: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (_, val, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: val, color: barColor, backgroundColor: bgColor),
                const SizedBox(height: 8),
                Text('${(val * 100).round()} %'),
              ],
            ),
          ),
        ),
      ),
    );
    await Future.delayed(Duration.zero);

    // Pré-charger tous les IDs existants en mémoire (évite les requêtes par ligne)
    final existingNums = <int>{
      for (final r in await db.query('jumps', columns: ['num'])) r['num'] as int
    };
    final typeCache = <String, int>{
      for (final r in await db.query('jump_types', columns: ['id', 'name']))
        r['name'] as String: r['id'] as int
    };
    final dzCache = <String, int>{
      for (final r in await db.query('drop_zones', columns: ['id', 'name']))
        r['name'] as String: r['id'] as int
    };
    final aircraftCache = <String, int>{
      for (final r in await db.query('aircraft', columns: ['id', 'name']))
        r['name'] as String: r['id'] as int
    };
    final equipCache = <String, int>{
      for (final r in await db.query('equipment', columns: ['id', 'name', 'type']))
        '${r['name']}|${r['type']}': r['id'] as int
    };

    // Traitement des lignes avec caches
    final newJumps = <Map<String, dynamic>>[];

    for (var i = 1; i < rows.length; i++) {
      if (i % 50 == 0) {
        progress.value = (i / total) * 0.85;
        await Future.delayed(Duration.zero);
      }

      final row = rows[i];
      if (row.isEmpty) continue;

      final num = int.tryParse(row[0].toString().trim());
      if (num == null) { skipped++; continue; }
      if (existingNums.contains(num)) { skipped++; continue; }

      final date = _parseDate(row.length > 1 ? row[1].toString().trim() : '');
      if (date == null) { skipped++; continue; }

      final typeStr = row.length > 2 ? row[2].toString().trim() : '';
      final dzStr = row.length > 3 ? row[3].toString().trim() : '';
      final country = row.length > 4 ? row[4].toString().trim() : '';
      final aircraftStr = row.length > 5 ? row[5].toString().trim() : '';
      final bagStr = row.length > 6 ? row[6].toString().trim() : '';
      final canopyStr = row.length > 7 ? row[7].toString().trim() : '';
      final suitStr = row.length > 8 ? row[8].toString().trim() : '';
      final cutawayStr = row.length > 9 ? row[9].toString().trim().toLowerCase() : '';
      final notes = row.length > 10 ? row[10].toString().trim() : '';

      final jumpTypeId = typeStr.isEmpty ? null : await _cachedFindOrCreate(db, 'jump_types', typeStr, typeCache, {'is_default': 0, 'jumps_before': 0, 'notes': ''});
      final dropZoneId = dzStr.isEmpty ? null : await _cachedFindOrCreateDz(db, dzStr, country, dzCache);
      final aircraftId = aircraftStr.isEmpty ? null : await _cachedFindOrCreate(db, 'aircraft', aircraftStr, aircraftCache, {'is_default': 0, 'jumps_before': 0, 'notes': ''});
      final bagId = bagStr.isEmpty ? null : await _cachedFindOrCreateEquip(db, bagStr, 'bag', equipCache);
      final canopyId = canopyStr.isEmpty ? null : await _cachedFindOrCreateEquip(db, canopyStr, 'canopy', equipCache);
      final suitId = suitStr.isEmpty ? null : await _cachedFindOrCreateEquip(db, suitStr, 'suit', equipCache);
      final cutaway = cutawayStr == 'oui' || cutawayStr == 'yes' || cutawayStr == '1';

      newJumps.add({
        'num': num, 'date': date.toIso8601String(),
        'jump_type_id': jumpTypeId, 'drop_zone_id': dropZoneId,
        'aircraft_id': aircraftId, 'bag_id': bagId,
        'canopy_id': canopyId, 'suit_id': suitId,
        'cutaway': cutaway ? 1 : 0, 'notes': notes,
      });
    }

    // Insertion en une seule transaction
    await db.transaction((txn) async {
      for (final jump in newJumps) {
        await txn.insert('jumps', jump);
      }
    });

    final imported = newJumps.length;
    progress.value = 1.0;

    progress.dispose();
    if (context.mounted) Navigator.of(context).pop();

    ref.invalidate(jumpsProvider);
    ref.invalidate(summaryProvider);
    ref.invalidate(dropZonesProvider);
    ref.invalidate(jumpTypesProvider);
    ref.invalidate(aircraftProvider);
    ref.invalidate(bagsProvider);
    ref.invalidate(canopiesProvider);
    ref.invalidate(suitsProvider);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Import terminé'),
          content: Text(
            imported == 0
                ? 'Aucun nouveau saut importé.\n$skipped ignoré${skipped > 1 ? 's' : ''} (déjà présents ou invalides)'
                : '$imported saut${imported > 1 ? 's' : ''} importé${imported > 1 ? 's' : ''}'
                    '${skipped > 0 ? '\n$skipped ignoré${skipped > 1 ? 's' : ''} (déjà présents ou invalides)' : ''}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _contactDev(BuildContext context, WidgetRef ref) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'parazoom@etik.com',
      query: 'subject=Message%20venant%20de%20l%27application%20ParaBook',
    );
    await launchUrl(uri);
  }
}

String _detectDelimiter(String content) {
  final firstLine = content.split('\n').first;
  final commas = firstLine.split(',').length - 1;
  final semicolons = firstLine.split(';').length - 1;
  return semicolons > commas ? ';' : ',';
}

List<String> _checkCsvFormat(List<List<dynamic>> rows, String delimiter) {
  final issues = <String>[];

  if (delimiter == ';') {
    issues.add(
      'Séparateur « ; » (point-virgule) détecté.\n'
      'Le format attendu utilise « , » (virgule).',
    );
  }

  if (rows.isEmpty) {
    issues.add('Le fichier est vide.');
    return issues;
  }

  final header = rows[0];
  if (header.length < 2) {
    issues.add(
      'L\'en-tête ne contient qu\'une seule colonne.\n'
      'Vérifiez que le séparateur est bien la virgule.',
    );
    return issues;
  }

  const expected = [
    'num', 'date', 'type', 'dz', 'country',
    'plane', 'bag', 'canopy', 'suit', 'cut away', 'notes',
  ];
  final mismatches = <String>[];
  for (var i = 0; i < expected.length && i < header.length; i++) {
    if (header[i].toString().trim().toLowerCase() != expected[i].toLowerCase()) {
      mismatches.add('col ${i + 1} : « ${header[i]} » ≠ « ${expected[i]} »');
    }
  }
  if (mismatches.isNotEmpty) {
    issues.add('En-tête : ${mismatches.join(', ')}');
  }
  if (header.length < expected.length) {
    issues.add(
      '${header.length} colonnes détectées, ${expected.length} attendues.',
    );
  }

  if (rows.length < 2) {
    issues.add('Aucune ligne de données (seulement l\'en-tête).');
    return issues;
  }

  final first = rows[1];
  if (first.isNotEmpty) {
    final numVal = int.tryParse(first[0].toString().trim());
    if (numVal == null) {
      issues.add(
        'Ligne 2 — colonne Num : « ${first[0]} » n\'est pas un entier.',
      );
    }
  }
  if (first.length > 1) {
    final dateStr = first[1].toString().trim();
    if (_parseDate(dateStr) == null) {
      issues.add(
        'Ligne 2 — colonne Date : « $dateStr » — format non reconnu.\n'
        'Formats acceptés : AAAA-MM-JJ ou JJ/MM/AAAA.',
      );
    }
  }

  return issues;
}

Future<bool?> _showFormatIssuesDialog(
  BuildContext context,
  List<String> issues,
  List<List<dynamic>> rows,
) {
  final canProceed = rows.length > 1 && (rows[0].length) >= 2;
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Format CSV incompatible'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...issues.map((issue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(issue)),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            const Text(
              'Format attendu :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'num,date,type,dz,country,plane,\nbag,canopy,suit,cut away,notes',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        if (canProceed)
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Importer quand même'),
          ),
      ],
    ),
  );
}

DateTime? _parseDate(String s) {
  if (s.isEmpty) return null;
  try {
    return DateTime.parse(s);
  } catch (_) {}
  final parts = s.split('/');
  if (parts.length == 3) {
    try {
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {}
  }
  return null;
}

Future<int> _cachedFindOrCreate(
  Database db, String table, String name, Map<String, int> cache,
  Map<String, dynamic> defaults,
) async {
  if (cache.containsKey(name)) return cache[name]!;
  final id = await db.insert(table, {'name': name, ...defaults});
  cache[name] = id;
  return id;
}

Future<int> _cachedFindOrCreateDz(
  Database db, String name, String country, Map<String, int> cache,
) async {
  if (cache.containsKey(name)) return cache[name]!;
  final id = await db.insert('drop_zones', {
    'name': name, 'country': country,
    'is_default': 0, 'jumps_before': 0, 'notes': '',
  });
  cache[name] = id;
  return id;
}

Future<int> _cachedFindOrCreateEquip(
  Database db, String name, String type, Map<String, int> cache,
) async {
  final key = '$name|$type';
  if (cache.containsKey(key)) return cache[key]!;
  final id = await db.insert('equipment', {
    'name': name, 'type': type,
    'is_default': 0, 'is_archived': 0, 'jumps_before': 0, 'notes': '',
  });
  cache[key] = id;
  return id;
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 1.2,
          )),
    );
  }
}
