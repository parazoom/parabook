import 'package:flutter/material.dart';
import 'package:parabook/l10n/app_localizations.dart';

class InfoHelpScreen extends StatelessWidget {
  const InfoHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
    final changelog = _buildChangelog(l);

    return Scaffold(
      appBar: AppBar(title: Text(l.infoAndHelp)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 + MediaQuery.of(context).padding.left, 16, 16 + MediaQuery.of(context).padding.right, 16 + MediaQuery.of(context).padding.bottom),
        children: [
          _SectionTitle(l.about, primary),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l.aboutText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(l.help, primary),
          _ExpandableSection(
            title: l.helpImportCsvTitle,
            primary: primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.helpCsvFormat,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l.helpCsvColumns,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.helpCsvDetails,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _ExpandableSection(
            title: l.helpUsage,
            primary: primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HelpParagraph(context, title: l.helpSummaryTitle, text: l.helpSummaryText),
                _HelpParagraph(context, title: l.helpJumpsTitle, text: l.helpJumpsText),
                _HelpParagraph(context, title: l.helpStatsTitle, text: l.helpStatsText),
                _HelpParagraph(context, title: l.helpListsTitle, text: l.helpListsText),
                _HelpParagraph(context, title: l.helpActionsTitle, text: l.helpActionsText),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(l.changelog, primary),
          ...changelog.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChangelogVersionCard(entry: e, primary: primary),
          )),
        ],
      ),
    );
  }
}

// ── Changelog data ─────────────────────────────────────────────────────────

class _CSection {
  final String label;
  final List<String> items;
  const _CSection(this.label, this.items);
}

class _ChangelogEntry {
  final String version;
  final String date;
  final List<_CSection> sections;
  const _ChangelogEntry(this.version, this.date, this.sections);
}

List<_ChangelogEntry> _buildChangelog(AppLocalizations l) => [
  _ChangelogEntry('1.2.0', l.changelog120date, [
    _CSection(l.changelogAdded, [
      l.changelog120added1,
      l.changelog120added2,
      l.changelog120added3,
    ]),
  ]),
  _ChangelogEntry('1.0.0', l.changelog100date, [
    _CSection(l.changelogAdded, [
      l.changelog100note,
    ]),
    _CSection(l.changelogFixed, [
      l.changelog100fixedShare,
      l.changelog100fixedSave,
    ]),
  ]),
  _ChangelogEntry('0.9.3', l.changelog093date, [
    _CSection(l.changelogAdded, [
      l.changelog093added0,
      l.changelog093addedLandscape,
      l.changelog093addedCutaway,
      l.changelog093added1,
      l.changelog093added2,
    ]),
    _CSection(l.changelogFixed, [
      l.changelog093fixedNavBar,
      l.changelog093fixed1,
      l.changelog093fixed2,
      l.changelog093fixed3,
    ]),
  ]),
  _ChangelogEntry('0.9.2', l.changelog092date, [
    _CSection(l.changelogFixed, [
      l.changelog092fixed1,
      l.changelog092fixed2,
      l.changelog092fixed3,
    ]),
  ]),
  _ChangelogEntry('0.9.1', l.changelog091date, [
    _CSection(l.changelogAdded, [
      l.changelog091added1,
      l.changelog091added2,
      l.changelog091added3,
    ]),
    _CSection(l.changelogFixed, [
      l.changelog091fixed1,
    ]),
  ]),
  _ChangelogEntry('0.9.0', l.changelog090date, [
    _CSection(l.changelogAdded, [
      l.changelog090added1,
      l.changelog090added2,
      l.changelog090added3,
      l.changelog090added4,
      l.changelog090added5,
      l.changelog090added6,
    ]),
  ]),
];

// ── Changelog widgets ───────────────────────────────────────────────────────

class _ChangelogVersionCard extends StatelessWidget {
  final _ChangelogEntry entry;
  final Color primary;
  const _ChangelogVersionCard({required this.entry, required this.primary});

  @override
  Widget build(BuildContext context) {
    return _ExpandableSection(
      title: 'v${entry.version}  —  ${entry.date}',
      primary: primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entry.sections.map((s) => _CSectionWidget(section: s)).toList(),
      ),
    );
  }
}

class _CSectionWidget extends StatelessWidget {
  final _CSection section;
  const _CSectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          ...section.items.map((item) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 13)),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 13))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 1.2,
          )),
    );
  }
}

class _ExpandableSection extends StatefulWidget {
  final String title;
  final Color primary;
  final Widget child;
  const _ExpandableSection({required this.title, required this.primary, required this.child});

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

class _HelpParagraph extends StatelessWidget {
  final String title;
  final String text;
  final BuildContext ctx;
  const _HelpParagraph(this.ctx, {required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
