import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import '../../db/database.dart';
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres application')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
        children: [
          _SectionTitle(l.language),
          Card(
            child: RadioGroup<String>(
              groupValue: settings.locale.languageCode,
              onChanged: (v) { if (v != null) notifier.setLocale(Locale(v)); },
              child: const Column(
                children: [
                  RadioListTile<String>(title: Text('Français'), value: 'fr'),
                  RadioListTile<String>(title: Text('English'), value: 'en'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(l.theme),
          Card(
            child: Column(children: [
              _ColorTile(
                label: l.backgroundColor,
                color: settings.backgroundColor,
                onChanged: (c) => notifier.setColors(bg: c),
              ),
              Divider(height: 1),
              _ColorTile(
                label: l.primaryColor,
                color: settings.primaryColor,
                onChanged: (c) => notifier.setColors(primary: c),
              ),
              Divider(height: 1),
              _ColorTile(
                label: l.textColor,
                color: settings.textColor,
                onChanged: (c) => notifier.setColors(text: c),
              ),
              Divider(height: 1),
              _ColorTile(
                label: 'Couleur secondaire',
                color: settings.secondaryColor,
                onChanged: (c) => notifier.setColors(secondary: c),
              ),
              Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: Text(l.resetTheme),
                onTap: () => notifier.resetTheme(),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          _SectionTitle(l.emailAddress),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _EmailField(
                initial: settings.emailAddress,
                onSaved: (v) => notifier.setEmailAddress(v),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Pays de résidence'),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _ResidenceCountryField(
                initial: settings.residenceCountry,
                onSaved: (v) => notifier.setResidenceCountry(v),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Sauts avant l\'application'),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _JumpsBeforeField(
                initial: settings.jumpsBefore,
                onSaved: (v) => notifier.setJumpsBefore(v),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Données'),
          Card(
            child: Column(children: [
              ListTile(
                leading: Icon(Icons.delete_sweep, color: Colors.red[400]),
                title: const Text('Purger toutes les listes'),
                subtitle: const Text('Zones, types, aéronefs, équipements'),
                onTap: () => _purgeLists(context, ref),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red[700]),
                title: const Text('Réinitialiser le carnet de sauts'),
                subtitle: const Text('Supprime tous les sauts et toutes les listes'),
                onTap: () => _resetAll(context, ref),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _purgeLists(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Purger toutes les listes ?'),
        content: const Text(
          'Supprime toutes les zones de saut, types de saut, aéronefs et équipements.\n\n'
          'Les sauts existants ne sont pas supprimés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Purger'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final db = await AppDatabase.instance;
    await db.delete('drop_zones');
    await db.delete('jump_types');
    await db.delete('aircraft');
    await db.delete('equipment');

    ref.invalidate(dropZonesProvider);
    ref.invalidate(jumpTypesProvider);
    ref.invalidate(aircraftProvider);
    ref.invalidate(bagsProvider);
    ref.invalidate(canopiesProvider);
    ref.invalidate(suitsProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listes purgées')),
      );
    }
  }

  Future<void> _resetAll(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Réinitialiser le carnet ?'),
        content: const Text(
          'Cette action supprime définitivement TOUS les sauts, toutes les zones de saut, '
          'types, aéronefs et équipements.\n\n'
          'Cette opération est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Tout supprimer'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final db = await AppDatabase.instance;
    await db.delete('jumps');
    await db.delete('drop_zones');
    await db.delete('jump_types');
    await db.delete('aircraft');
    await db.delete('equipment');

    ref.invalidate(jumpsProvider);
    ref.invalidate(summaryProvider);
    ref.invalidate(dropZonesProvider);
    ref.invalidate(jumpTypesProvider);
    ref.invalidate(aircraftProvider);
    ref.invalidate(bagsProvider);
    ref.invalidate(canopiesProvider);
    ref.invalidate(suitsProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carnet réinitialisé')),
      );
    }
  }
}

class _EmailField extends StatefulWidget {
  final String initial;
  final void Function(String) onSaved;
  const _EmailField({required this.initial, required this.onSaved});

  @override
  State<_EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<_EmailField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return TextField(
      controller: _ctrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: l.emailAddress,
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => widget.onSaved(_ctrl.text.trim()),
        ),
      ),
      onSubmitted: widget.onSaved,
    );
  }
}

class _ColorTile extends StatelessWidget {
  final String label;
  final Color color;
  final void Function(Color) onChanged;

  const _ColorTile({required this.label, required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: GestureDetector(
        onTap: () => _pickColor(context),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white24),
          ),
        ),
      ),
    );
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ColorPickerDialog(current: color, onPicked: onChanged),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color current;
  final void Function(Color) onPicked;
  const _ColorPickerDialog({required this.current, required this.onPicked});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late TextEditingController _ctrl;
  late Color _selected;

  static const _swatches = [
    Color(0xFFF44336), Color(0xFFE91E63), Color(0xFFFF5722), Color(0xFFF54927),
    Color(0xFFFF9800), Color(0xFFFFEB3B), Color(0xFF8BC34A), Color(0xFF4CAF50),
    Color(0xFF009688), Color(0xFF00BCD4), Color(0xFF2196F3), Color(0xFF3F51B5),
    Color(0xFF9C27B0), Color(0xFF607D8B), Color(0xFF795548), Color(0xFFFFFFFF),
    Color(0xFFE0E0E0), Color(0xFFBDBDBD), Color(0xFF9E9E9E), Color(0xFF757575),
    Color(0xFF424242), Color(0xFF212121), Color(0xFF000000), Color(0xFF00E5FF),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
    _ctrl = TextEditingController(
      text: '#${widget.current.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choisir une couleur'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: _selected,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _swatches.map((c) {
                final isSelected = _selected.toARGB32() == c.toARGB32();
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected = c;
                      _ctrl.text =
                          '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white24,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              decoration: const InputDecoration(labelText: 'Code hex', hintText: '#RRGGBB'),
              onChanged: (v) {
                try {
                  final hex = v.replaceAll('#', '');
                  if (hex.length == 6) {
                    setState(() {
                      _selected = Color(int.parse('FF$hex', radix: 16));
                    });
                  }
                } catch (_) {}
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            widget.onPicked(_selected);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _JumpsBeforeField extends StatefulWidget {
  final int initial;
  final void Function(int) onSaved;
  const _JumpsBeforeField({required this.initial, required this.onSaved});

  @override
  State<_JumpsBeforeField> createState() => _JumpsBeforeFieldState();
}

class _JumpsBeforeFieldState extends State<_JumpsBeforeField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.initial}');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Nombre de sauts avant l\'application',
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => widget.onSaved(int.tryParse(_ctrl.text.trim()) ?? 0),
        ),
      ),
      onSubmitted: (v) => widget.onSaved(int.tryParse(v.trim()) ?? 0),
    );
  }
}

class _ResidenceCountryField extends StatefulWidget {
  final String initial;
  final void Function(String) onSaved;
  const _ResidenceCountryField({required this.initial, required this.onSaved});

  @override
  State<_ResidenceCountryField> createState() => _ResidenceCountryFieldState();
}

class _ResidenceCountryFieldState extends State<_ResidenceCountryField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Pays de résidence',
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => widget.onSaved(_ctrl.text.trim()),
        ),
      ),
      onSubmitted: (v) => widget.onSaved(v.trim()),
    );
  }
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
