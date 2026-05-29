import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

class SkydiversSettingsScreen extends ConsumerWidget {
  const SkydiversSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: const Text('Paramètres parachutiste'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _SaveField(
                label: 'Numéro de licence',
                initial: settings.licenseNumber,
                onSaved: notifier.setLicenseNumber,
                keyboardType: TextInputType.text,
                capitalization: TextCapitalization.characters,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _InfosCard(initial: settings.skydiversInfo, onSaved: notifier.setSkydiversInfo),
        ],
      ),
    );
  }
}

class _InfosCard extends StatefulWidget {
  final String initial;
  final Future<void> Function(String) onSaved;
  const _InfosCard({required this.initial, required this.onSaved});

  @override
  State<_InfosCard> createState() => _InfosCardState();
}

class _InfosCardState extends State<_InfosCard> {
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Infos'),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Enregistrer'),
                onPressed: () => widget.onSaved(_ctrl.text.trim()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveField extends StatefulWidget {
  final String label;
  final String initial;
  final Future<void> Function(String) onSaved;
  final TextInputType keyboardType;
  final TextCapitalization capitalization;

  const _SaveField({
    required this.label,
    required this.initial,
    required this.onSaved,
    required this.keyboardType,
    required this.capitalization,
  });

  @override
  State<_SaveField> createState() => _SaveFieldState();
}

class _SaveFieldState extends State<_SaveField> {
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
      keyboardType: widget.keyboardType,
      textCapitalization: widget.capitalization,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => widget.onSaved(_ctrl.text.trim()),
        ),
      ),
      onSubmitted: (v) => widget.onSaved(v.trim()),
    );
  }
}
