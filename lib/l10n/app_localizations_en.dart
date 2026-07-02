// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ParaBook';

  @override
  String get tabSummary => 'Summary';

  @override
  String get tabJumps => 'Jumps';

  @override
  String get tabStats => 'Totals';

  @override
  String get tabLists => 'Lists';

  @override
  String get tabActions => 'Actions';

  @override
  String get totalJumps => 'Total jumps';

  @override
  String get cutaways => 'Cutaways';

  @override
  String get dropZones => 'Drop zones';

  @override
  String get countries => 'Countries';

  @override
  String get lastJump => 'Last jump';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get last12Months => 'Last 12 months';

  @override
  String get addJump => 'Add a jump';

  @override
  String get copyLastJump => 'Copy last jump';

  @override
  String get jumpNumber => 'Jump #';

  @override
  String get jumpNumberExists => 'This jump number already exists.';

  @override
  String get date => 'Date';

  @override
  String get dropZone => 'Drop zone';

  @override
  String get aircraft => 'Aircraft';

  @override
  String get canopy => 'Canopy';

  @override
  String get bag => 'Container';

  @override
  String get suit => 'Suit';

  @override
  String get jumpType => 'Jump type';

  @override
  String get cutaway => 'Cutaway';

  @override
  String get notes => 'Notes';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get name => 'Name';

  @override
  String get country => 'Country';

  @override
  String get isDefault => 'Default';

  @override
  String get jumpsBefore => 'Previous jumps';

  @override
  String get isArchived => 'Archived';

  @override
  String get reminderDate => 'Reminder date';

  @override
  String get equipment => 'Equipment';

  @override
  String get active => 'Active';

  @override
  String get archived => 'Archived';

  @override
  String get byDropZone => 'By drop zone';

  @override
  String get byAircraft => 'By aircraft';

  @override
  String get byEquipment => 'By equipment';

  @override
  String get byJumpType => 'By jump type';

  @override
  String get byYear => 'By year';

  @override
  String get byCountry => 'By country';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get exportShare => 'Share';

  @override
  String get exportFile => 'Export to file';

  @override
  String get exportEmailSubject => 'ParaBook — Logbook export';

  @override
  String get exportEmailBody =>
      'Attached is my ParaBook logbook export (CSV file).';

  @override
  String exportSaved(String path) {
    return 'Saved: $path';
  }

  @override
  String get exportCancelled => 'Export cancelled';

  @override
  String get importCsv => 'Import CSV';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get backgroundColor => 'Background color';

  @override
  String get primaryColor => 'Primary color';

  @override
  String get textColor => 'Text color';

  @override
  String get defaults => 'Defaults';

  @override
  String get info => 'Info';

  @override
  String get help => 'Help';

  @override
  String get contactDeveloper => 'Contact developer';

  @override
  String get reminderSoon => 'Reminder in less than a month';

  @override
  String get reminderOverdue => 'Reminder overdue';

  @override
  String get confirmDelete => 'Delete this item?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get noJumps => 'No jumps recorded';

  @override
  String get noJumpsFiltered => 'No jump matches these filters';

  @override
  String get filterJumps => 'Filter jumps';

  @override
  String get filterDateFrom => 'From';

  @override
  String get filterDateTo => 'To';

  @override
  String get filterSearchNotes => 'Search in notes';

  @override
  String get filterCutawayOnly => 'Cutaways only';

  @override
  String get resetFilters => 'Reset';

  @override
  String get applyFilters => 'Filter';

  @override
  String get filtersActive => 'Filters active';

  @override
  String get num => '#';

  @override
  String get location => 'Location';

  @override
  String get type => 'Type';

  @override
  String get emailAddress => 'Email address';

  @override
  String get bags => 'Containers';

  @override
  String get canopies => 'Canopies';

  @override
  String get suits => 'Suits';

  @override
  String get jumpTypes => 'Jump types';

  @override
  String get aircraftList => 'Aircraft';

  @override
  String get addDropZone => 'Add a DZ';

  @override
  String get addEquipment => 'Add equipment';

  @override
  String get addJumpType => 'Add jump type';

  @override
  String get addAircraft => 'Add aircraft';

  @override
  String get editJump => 'Edit jump';

  @override
  String get jumps => 'jumps';

  @override
  String get defaultsDescription => 'Items checked as default';

  @override
  String get resetTheme => 'Reset theme';

  @override
  String get infoAndHelp => 'Info & Help';

  @override
  String get changelog => 'What\'s new';

  @override
  String get about => 'About';

  @override
  String get aboutText =>
      'This app is a copy of Skydive Logbook, which was no longer maintained, with a few changes to fit my needs.\n\nIf you have improvement ideas, they are welcome — use the contact form for that.\n\nDeveloped by Ludo PARAZOOM.';

  @override
  String get helpImportCsvTitle => 'Import CSV';

  @override
  String get helpCsvFormat => 'The CSV file must have the following format:';

  @override
  String get helpCsvColumns =>
      'Num, Date, Type, Drop Zone, Country,\nAircraft, Container, Canopy, Suit,\nCutaway, Notes';

  @override
  String get helpCsvDetails =>
      '• Columns must be separated by commas.\n• Date format: YYYY-MM-DD or DD/MM/YYYY.\n• The Cutaway column accepts: Yes, Oui or 1.\n• To create a CSV file, use a spreadsheet:\n  Google Sheets, LibreOffice Calc or Excel,\n  then export as \"CSV (comma separated)\".';

  @override
  String get helpUsage => 'Usage';

  @override
  String get helpSummaryTitle => 'Summary';

  @override
  String get helpSummaryText =>
      'The home page shows your overall statistics: total jumps, cutaways, drop zones visited, countries, last jump, and activity over the last 30 days and 12 months. If you have jumps made before the app, enter them in App Settings → \"Jumps before app\". Useful links and your license information are also shown here.';

  @override
  String get helpJumpsTitle => 'Jumps';

  @override
  String get helpJumpsText =>
      'List of all your jumps, from most recent to oldest. Tap a jump to view or edit it. The + button adds a new jump. The copy button duplicates the last recorded jump (handy for repetitive jumps at the same DZ with the same gear).';

  @override
  String get helpStatsTitle => 'Stats';

  @override
  String get helpStatsText =>
      'View the breakdown of your jumps by drop zone, aircraft, equipment (container, canopy, suit), jump type and year. Bars are proportional to the entry with the most jumps. Previous jumps (the \"Previous jumps\" field of each entry) are included in the totals.';

  @override
  String get helpListsTitle => 'Lists';

  @override
  String get helpListsText =>
      'Manage your references: equipment (container, canopy, suit), drop zones, jump types, aircraft and useful links. For each entry, you can set a default value (pre-selected when adding a jump) and enter \"previous jumps\" to count usage before the app. Equipment can be archived to no longer appear in jump entry.';

  @override
  String get helpActionsTitle => 'Actions';

  @override
  String get helpActionsText =>
      'Import your old jumps from a CSV file (see the Import CSV section above). Export your logbook by email or to a local file. Access app settings (theme, language, email) and skydiver settings (license, info). Contact the developer from this page.';

  @override
  String get changelogAdded => 'Added';

  @override
  String get changelogFixed => 'Fixed';

  @override
  String get changelog120date => 'July 1, 2026';

  @override
  String get changelog120added1 =>
      'Filter on the jumps list: date range, search in notes, cutaway, drop zone, country, aircraft and jump type';

  @override
  String get changelog120added2 =>
      'CSV import: jump number validation (duplicates blocked, missing numbers flagged)';

  @override
  String get changelog120added3 =>
      'Adding or editing a jump: can no longer enter a jump number that\'s already in use';

  @override
  String get changelog100date => 'May 29, 2026';

  @override
  String get changelog100note => 'First public release on Google Play.';

  @override
  String get changelog100fixedShare =>
      '\"Export by email\" is now \"Share\": send your CSV export to any app (messaging, mail, cloud…)';

  @override
  String get changelog100fixedSave =>
      'File export now lets you save the CSV to the Downloads folder';

  @override
  String get changelog093date => 'May 28, 2026';

  @override
  String get changelog093added0 => 'New app icon';

  @override
  String get changelog093addedLandscape =>
      'Jump list in landscape: date/type, aircraft, equipment and notes columns';

  @override
  String get changelog093addedCutaway =>
      'Parachute icon in jump list when a cutaway is recorded';

  @override
  String get changelog093added1 =>
      '\"By country\" tab in Totals: breakdown of jumps by country';

  @override
  String get changelog093added2 => '\"What\'s new\" section in Info & Help';

  @override
  String get changelog093fixedNavBar =>
      'Android navigation bar overlapping content on all screens (portrait & landscape)';

  @override
  String get changelog093fixed1 =>
      'Spelling: \"Béni Mellal\" (formerly \"Beni Melal\")';

  @override
  String get changelog093fixed2 =>
      'Custom text color not applied everywhere (titles, subtitles, labels, dropdowns)';

  @override
  String get changelog093fixed3 =>
      'Default language: English (instead of French)';

  @override
  String get changelog092date => 'May 27, 2026';

  @override
  String get changelog092fixed1 =>
      'Forms: Save / Cancel / Delete buttons hidden behind Android navigation bar';

  @override
  String get changelog092fixed2 =>
      'Forms: content too long with no scroll possible — fixed';

  @override
  String get changelog092fixed3 =>
      'android:label correctly displayed as \"ParaBook\" in Android launcher';

  @override
  String get changelog091date => 'May 27, 2026';

  @override
  String get changelog091added1 =>
      'Archiving of drop zones, aircraft and jump types';

  @override
  String get changelog091added2 =>
      'Archived items no longer appear in dropdowns';

  @override
  String get changelog091added3 => 'Active / Archived separation in lists';

  @override
  String get changelog091fixed1 =>
      'Copy a jump: the copied date is the original jump\'s date (not today)';

  @override
  String get changelog090date => 'May 21, 2026';

  @override
  String get changelog090added1 => 'Custom useful links with browser opening';

  @override
  String get changelog090added2 => '\"Useful links\" tab in the Lists screen';

  @override
  String get changelog090added3 =>
      'Active / Archived section in equipment list';

  @override
  String get changelog090added4 => 'Info & Help screen localized FR / EN';

  @override
  String get changelog090added5 =>
      'Jump pagination for large logbooks (10,000+ jumps)';

  @override
  String get changelog090added6 =>
      'Optimized CSV import: memory cache, single transaction';
}
