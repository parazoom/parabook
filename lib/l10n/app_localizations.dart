import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'ParaBook'**
  String get appTitle;

  /// No description provided for @tabSummary.
  ///
  /// In fr, this message translates to:
  /// **'Résumé'**
  String get tabSummary;

  /// No description provided for @tabJumps.
  ///
  /// In fr, this message translates to:
  /// **'Sauts'**
  String get tabJumps;

  /// No description provided for @tabStats.
  ///
  /// In fr, this message translates to:
  /// **'Totaux'**
  String get tabStats;

  /// No description provided for @tabLists.
  ///
  /// In fr, this message translates to:
  /// **'Listes'**
  String get tabLists;

  /// No description provided for @tabActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions'**
  String get tabActions;

  /// No description provided for @totalJumps.
  ///
  /// In fr, this message translates to:
  /// **'Total des sauts'**
  String get totalJumps;

  /// No description provided for @cutaways.
  ///
  /// In fr, this message translates to:
  /// **'Libérations'**
  String get cutaways;

  /// No description provided for @dropZones.
  ///
  /// In fr, this message translates to:
  /// **'Zones de saut'**
  String get dropZones;

  /// No description provided for @countries.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get countries;

  /// No description provided for @lastJump.
  ///
  /// In fr, this message translates to:
  /// **'Dernier saut'**
  String get lastJump;

  /// No description provided for @last30Days.
  ///
  /// In fr, this message translates to:
  /// **'30 derniers jours'**
  String get last30Days;

  /// No description provided for @last12Months.
  ///
  /// In fr, this message translates to:
  /// **'12 derniers mois'**
  String get last12Months;

  /// No description provided for @addJump.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un saut'**
  String get addJump;

  /// No description provided for @copyLastJump.
  ///
  /// In fr, this message translates to:
  /// **'Copier le dernier saut'**
  String get copyLastJump;

  /// No description provided for @jumpNumber.
  ///
  /// In fr, this message translates to:
  /// **'Saut n°'**
  String get jumpNumber;

  /// No description provided for @jumpNumberExists.
  ///
  /// In fr, this message translates to:
  /// **'Ce numéro de saut existe déjà.'**
  String get jumpNumberExists;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dropZone.
  ///
  /// In fr, this message translates to:
  /// **'Zone de saut'**
  String get dropZone;

  /// No description provided for @aircraft.
  ///
  /// In fr, this message translates to:
  /// **'Aéronef'**
  String get aircraft;

  /// No description provided for @canopy.
  ///
  /// In fr, this message translates to:
  /// **'Voile'**
  String get canopy;

  /// No description provided for @bag.
  ///
  /// In fr, this message translates to:
  /// **'Sac'**
  String get bag;

  /// No description provided for @suit.
  ///
  /// In fr, this message translates to:
  /// **'Combinaison'**
  String get suit;

  /// No description provided for @jumpType.
  ///
  /// In fr, this message translates to:
  /// **'Type de saut'**
  String get jumpType;

  /// No description provided for @cutaway.
  ///
  /// In fr, this message translates to:
  /// **'Libération'**
  String get cutaway;

  /// No description provided for @notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @country.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get country;

  /// No description provided for @isDefault.
  ///
  /// In fr, this message translates to:
  /// **'Défaut'**
  String get isDefault;

  /// No description provided for @jumpsBefore.
  ///
  /// In fr, this message translates to:
  /// **'Sauts précédents'**
  String get jumpsBefore;

  /// No description provided for @isArchived.
  ///
  /// In fr, this message translates to:
  /// **'Archivé'**
  String get isArchived;

  /// No description provided for @reminderDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de rappel'**
  String get reminderDate;

  /// No description provided for @equipment.
  ///
  /// In fr, this message translates to:
  /// **'Équipements'**
  String get equipment;

  /// No description provided for @active.
  ///
  /// In fr, this message translates to:
  /// **'Actifs'**
  String get active;

  /// No description provided for @archived.
  ///
  /// In fr, this message translates to:
  /// **'Archivés'**
  String get archived;

  /// No description provided for @byDropZone.
  ///
  /// In fr, this message translates to:
  /// **'Par zone de saut'**
  String get byDropZone;

  /// No description provided for @byAircraft.
  ///
  /// In fr, this message translates to:
  /// **'Par aéronef'**
  String get byAircraft;

  /// No description provided for @byEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Par équipement'**
  String get byEquipment;

  /// No description provided for @byJumpType.
  ///
  /// In fr, this message translates to:
  /// **'Par type de saut'**
  String get byJumpType;

  /// No description provided for @byYear.
  ///
  /// In fr, this message translates to:
  /// **'Par année'**
  String get byYear;

  /// No description provided for @byCountry.
  ///
  /// In fr, this message translates to:
  /// **'Par pays'**
  String get byCountry;

  /// No description provided for @import.
  ///
  /// In fr, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @export.
  ///
  /// In fr, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exportShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get exportShare;

  /// No description provided for @exportFile.
  ///
  /// In fr, this message translates to:
  /// **'Exporter en fichier'**
  String get exportFile;

  /// No description provided for @exportEmailSubject.
  ///
  /// In fr, this message translates to:
  /// **'ParaBook — Export du logbook'**
  String get exportEmailSubject;

  /// No description provided for @exportEmailBody.
  ///
  /// In fr, this message translates to:
  /// **'Voici l\'export de mon logbook ParaBook (fichier CSV) en pièce jointe.'**
  String get exportEmailBody;

  /// No description provided for @exportSaved.
  ///
  /// In fr, this message translates to:
  /// **'Enregistré : {path}'**
  String exportSaved(String path);

  /// No description provided for @exportCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Export annulé'**
  String get exportCancelled;

  /// No description provided for @importCsv.
  ///
  /// In fr, this message translates to:
  /// **'Importer un CSV'**
  String get importCsv;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @backgroundColor.
  ///
  /// In fr, this message translates to:
  /// **'Couleur de fond'**
  String get backgroundColor;

  /// No description provided for @primaryColor.
  ///
  /// In fr, this message translates to:
  /// **'Couleur principale'**
  String get primaryColor;

  /// No description provided for @textColor.
  ///
  /// In fr, this message translates to:
  /// **'Couleur du texte'**
  String get textColor;

  /// No description provided for @defaults.
  ///
  /// In fr, this message translates to:
  /// **'Défauts'**
  String get defaults;

  /// No description provided for @info.
  ///
  /// In fr, this message translates to:
  /// **'Infos'**
  String get info;

  /// No description provided for @help.
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get help;

  /// No description provided for @contactDeveloper.
  ///
  /// In fr, this message translates to:
  /// **'Contacter le développeur'**
  String get contactDeveloper;

  /// No description provided for @reminderSoon.
  ///
  /// In fr, this message translates to:
  /// **'Rappel dans moins d\'un mois'**
  String get reminderSoon;

  /// No description provided for @reminderOverdue.
  ///
  /// In fr, this message translates to:
  /// **'Rappel dépassé'**
  String get reminderOverdue;

  /// No description provided for @confirmDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cet élément ?'**
  String get confirmDelete;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @noJumps.
  ///
  /// In fr, this message translates to:
  /// **'Aucun saut enregistré'**
  String get noJumps;

  /// No description provided for @noJumpsFiltered.
  ///
  /// In fr, this message translates to:
  /// **'Aucun saut ne correspond à ces filtres'**
  String get noJumpsFiltered;

  /// No description provided for @filterJumps.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer les sauts'**
  String get filterJumps;

  /// No description provided for @filterDateFrom.
  ///
  /// In fr, this message translates to:
  /// **'Du'**
  String get filterDateFrom;

  /// No description provided for @filterDateTo.
  ///
  /// In fr, this message translates to:
  /// **'Au'**
  String get filterDateTo;

  /// No description provided for @filterSearchNotes.
  ///
  /// In fr, this message translates to:
  /// **'Recherche dans les notes'**
  String get filterSearchNotes;

  /// No description provided for @filterCutawayOnly.
  ///
  /// In fr, this message translates to:
  /// **'Libérations uniquement'**
  String get filterCutawayOnly;

  /// No description provided for @resetFilters.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetFilters;

  /// No description provided for @applyFilters.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer'**
  String get applyFilters;

  /// No description provided for @filtersActive.
  ///
  /// In fr, this message translates to:
  /// **'Filtres actifs'**
  String get filtersActive;

  /// No description provided for @num.
  ///
  /// In fr, this message translates to:
  /// **'N°'**
  String get num;

  /// No description provided for @location.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get location;

  /// No description provided for @type.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @emailAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email'**
  String get emailAddress;

  /// No description provided for @bags.
  ///
  /// In fr, this message translates to:
  /// **'Sacs'**
  String get bags;

  /// No description provided for @canopies.
  ///
  /// In fr, this message translates to:
  /// **'Voiles'**
  String get canopies;

  /// No description provided for @suits.
  ///
  /// In fr, this message translates to:
  /// **'Combinaisons'**
  String get suits;

  /// No description provided for @jumpTypes.
  ///
  /// In fr, this message translates to:
  /// **'Types de saut'**
  String get jumpTypes;

  /// No description provided for @aircraftList.
  ///
  /// In fr, this message translates to:
  /// **'Aéronefs'**
  String get aircraftList;

  /// No description provided for @addDropZone.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une DZ'**
  String get addDropZone;

  /// No description provided for @addEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un équipement'**
  String get addEquipment;

  /// No description provided for @addJumpType.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un type de saut'**
  String get addJumpType;

  /// No description provided for @addAircraft.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un aéronef'**
  String get addAircraft;

  /// No description provided for @editJump.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le saut'**
  String get editJump;

  /// No description provided for @jumps.
  ///
  /// In fr, this message translates to:
  /// **'sauts'**
  String get jumps;

  /// No description provided for @defaultsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Éléments cochés comme défaut'**
  String get defaultsDescription;

  /// No description provided for @resetTheme.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le thème'**
  String get resetTheme;

  /// No description provided for @infoAndHelp.
  ///
  /// In fr, this message translates to:
  /// **'Info & Aide'**
  String get infoAndHelp;

  /// No description provided for @changelog.
  ///
  /// In fr, this message translates to:
  /// **'Nouveautés'**
  String get changelog;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @aboutText.
  ///
  /// In fr, this message translates to:
  /// **'Cette application est une copie de Skydive Logbook, qui n\'était plus maintenue, avec quelques changements afin de coller avec mes besoins.\n\nSi vous avez des idées d\'amélioration, elles sont les bienvenues — utilisez le formulaire de contact pour ça.\n\nDéveloppé par Ludo PARAZOOM.'**
  String get aboutText;

  /// No description provided for @helpImportCsvTitle.
  ///
  /// In fr, this message translates to:
  /// **'Import CSV'**
  String get helpImportCsvTitle;

  /// No description provided for @helpCsvFormat.
  ///
  /// In fr, this message translates to:
  /// **'Le fichier CSV doit avoir le format suivant :'**
  String get helpCsvFormat;

  /// No description provided for @helpCsvColumns.
  ///
  /// In fr, this message translates to:
  /// **'Num, Date, Type, Drop Zone, Pays,\nAéronef, Sac, Voile, Combinaison,\nLibération, Notes'**
  String get helpCsvColumns;

  /// No description provided for @helpCsvDetails.
  ///
  /// In fr, this message translates to:
  /// **'• Les colonnes doivent être séparées par des virgules.\n• La date est au format AAAA-MM-JJ ou JJ/MM/AAAA.\n• La colonne Libération accepte : Oui, Yes ou 1.\n• Pour créer un fichier CSV, utilisez un tableur :\n  Google Sheets, LibreOffice Calc ou Excel,\n  puis exportez en format « CSV (séparateur virgule) ».'**
  String get helpCsvDetails;

  /// No description provided for @helpUsage.
  ///
  /// In fr, this message translates to:
  /// **'Utilisation'**
  String get helpUsage;

  /// No description provided for @helpSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résumé'**
  String get helpSummaryTitle;

  /// No description provided for @helpSummaryText.
  ///
  /// In fr, this message translates to:
  /// **'La page d\'accueil affiche vos statistiques globales : total de sauts, libérations, zones de saut visitées, pays, dernier saut, et activité sur les 30 derniers jours et les 12 derniers mois. Si vous avez des sauts effectués avant l\'application, renseignez-les dans Paramètres application → \"Sauts avant l\'application\". Les liens utiles et vos informations de licence s\'affichent également ici.'**
  String get helpSummaryText;

  /// No description provided for @helpJumpsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauts'**
  String get helpJumpsTitle;

  /// No description provided for @helpJumpsText.
  ///
  /// In fr, this message translates to:
  /// **'Liste de tous vos sauts, du plus récent au plus ancien. Appuyez sur un saut pour le consulter ou le modifier. Le bouton + ajoute un nouveau saut. Le bouton copie duplique le dernier saut enregistré (pratique pour des sauts répétitifs sur la même DZ avec le même matériel).'**
  String get helpJumpsText;

  /// No description provided for @helpStatsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Stats'**
  String get helpStatsTitle;

  /// No description provided for @helpStatsText.
  ///
  /// In fr, this message translates to:
  /// **'Visualisez la répartition de vos sauts par zone de saut, aéronef, équipement (sac, voile, combinaison), type de saut et année. Les barres sont proportionnelles à l\'entrée avec le plus grand nombre de sauts. Les sauts précédents (champ \"Sauts avant\" de chaque entrée) sont inclus dans les totaux.'**
  String get helpStatsText;

  /// No description provided for @helpListsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Listes'**
  String get helpListsTitle;

  /// No description provided for @helpListsText.
  ///
  /// In fr, this message translates to:
  /// **'Gérez vos référentiels : équipements (sac, voile, combinaison), zones de saut, types de saut, aéronefs et liens utiles. Pour chaque entrée, vous pouvez définir une valeur par défaut (pré-sélectionnée à la création d\'un saut) et renseigner des \"sauts précédents\" pour comptabiliser l\'usage antérieur à l\'application. Les équipements peuvent être archivés pour ne plus apparaître lors des saisies.'**
  String get helpListsText;

  /// No description provided for @helpActionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Actions'**
  String get helpActionsTitle;

  /// No description provided for @helpActionsText.
  ///
  /// In fr, this message translates to:
  /// **'Importez vos anciens sauts depuis un fichier CSV (voir la section Import CSV ci-dessus). Exportez votre carnet par e-mail ou en fichier local. Accédez aux paramètres de l\'application (thème, langue, e-mail) et aux paramètres parachutiste (licence, infos). Contactez le développeur depuis cette page.'**
  String get helpActionsText;

  /// No description provided for @changelogAdded.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté'**
  String get changelogAdded;

  /// No description provided for @changelogFixed.
  ///
  /// In fr, this message translates to:
  /// **'Corrigé'**
  String get changelogFixed;

  /// No description provided for @changelog120date.
  ///
  /// In fr, this message translates to:
  /// **'1 juillet 2026'**
  String get changelog120date;

  /// No description provided for @changelog120added1.
  ///
  /// In fr, this message translates to:
  /// **'Filtre sur la liste des sauts : date (entre deux dates), recherche dans les notes, libération, zone de saut, pays, aéronef et type de saut'**
  String get changelog120added1;

  /// No description provided for @changelog120added2.
  ///
  /// In fr, this message translates to:
  /// **'Import CSV : vérification de la numérotation des sauts (doublons bloqués, numéros manquants signalés)'**
  String get changelog120added2;

  /// No description provided for @changelog120added3.
  ///
  /// In fr, this message translates to:
  /// **'Ajout ou modification d\'un saut : impossible de saisir un numéro de saut déjà utilisé'**
  String get changelog120added3;

  /// No description provided for @changelog100date.
  ///
  /// In fr, this message translates to:
  /// **'29 mai 2026'**
  String get changelog100date;

  /// No description provided for @changelog100note.
  ///
  /// In fr, this message translates to:
  /// **'Première publication publique sur Google Play.'**
  String get changelog100note;

  /// No description provided for @changelog100fixedShare.
  ///
  /// In fr, this message translates to:
  /// **'« Exporter par email » devient « Partager » : envoyez votre export CSV vers n\'importe quelle app (messagerie, mail, cloud…)'**
  String get changelog100fixedShare;

  /// No description provided for @changelog100fixedSave.
  ///
  /// In fr, this message translates to:
  /// **'L\'export en fichier permet désormais d\'enregistrer le CSV dans le dossier Téléchargements'**
  String get changelog100fixedSave;

  /// No description provided for @changelog093date.
  ///
  /// In fr, this message translates to:
  /// **'28 mai 2026'**
  String get changelog093date;

  /// No description provided for @changelog093added0.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle icône de l\'application'**
  String get changelog093added0;

  /// No description provided for @changelog093addedLandscape.
  ///
  /// In fr, this message translates to:
  /// **'Liste des sauts en mode paysage : colonnes date/type, aéronef, équipements et notes'**
  String get changelog093addedLandscape;

  /// No description provided for @changelog093addedCutaway.
  ///
  /// In fr, this message translates to:
  /// **'Icône parachute dans la liste des sauts quand une libération est enregistrée'**
  String get changelog093addedCutaway;

  /// No description provided for @changelog093added1.
  ///
  /// In fr, this message translates to:
  /// **'Onglet \"Par pays\" dans les Totaux : répartition des sauts par pays'**
  String get changelog093added1;

  /// No description provided for @changelog093added2.
  ///
  /// In fr, this message translates to:
  /// **'Section \"Nouveautés\" dans Info & Aide'**
  String get changelog093added2;

  /// No description provided for @changelog093fixedNavBar.
  ///
  /// In fr, this message translates to:
  /// **'Barre de navigation Android chevauchant le contenu sur tous les écrans (portrait & paysage)'**
  String get changelog093fixedNavBar;

  /// No description provided for @changelog093fixed1.
  ///
  /// In fr, this message translates to:
  /// **'Orthographe \"Béni Mellal\" (anciennement \"Beni Melal\")'**
  String get changelog093fixed1;

  /// No description provided for @changelog093fixed2.
  ///
  /// In fr, this message translates to:
  /// **'Couleur du texte personnalisée non appliquée partout (titres, sous-titres, labels, dropdowns)'**
  String get changelog093fixed2;

  /// No description provided for @changelog093fixed3.
  ///
  /// In fr, this message translates to:
  /// **'Langue par défaut : Anglais (au lieu du Français)'**
  String get changelog093fixed3;

  /// No description provided for @changelog092date.
  ///
  /// In fr, this message translates to:
  /// **'27 mai 2026'**
  String get changelog092date;

  /// No description provided for @changelog092fixed1.
  ///
  /// In fr, this message translates to:
  /// **'Formulaires : boutons Enregistrer / Annuler / Supprimer masqués derrière la barre de navigation Android'**
  String get changelog092fixed1;

  /// No description provided for @changelog092fixed2.
  ///
  /// In fr, this message translates to:
  /// **'Formulaires : contenu trop long restait hors écran sans scroll possible — corrigé'**
  String get changelog092fixed2;

  /// No description provided for @changelog092fixed3.
  ///
  /// In fr, this message translates to:
  /// **'android:label affiché correctement \"ParaBook\" dans le lanceur Android'**
  String get changelog092fixed3;

  /// No description provided for @changelog091date.
  ///
  /// In fr, this message translates to:
  /// **'27 mai 2026'**
  String get changelog091date;

  /// No description provided for @changelog091added1.
  ///
  /// In fr, this message translates to:
  /// **'Archivage des zones de saut, aéronefs et types de saut'**
  String get changelog091added1;

  /// No description provided for @changelog091added2.
  ///
  /// In fr, this message translates to:
  /// **'Les éléments archivés n\'apparaissent plus dans les menus déroulants'**
  String get changelog091added2;

  /// No description provided for @changelog091added3.
  ///
  /// In fr, this message translates to:
  /// **'Séparation Actifs / Archivés dans les listes'**
  String get changelog091added3;

  /// No description provided for @changelog091fixed1.
  ///
  /// In fr, this message translates to:
  /// **'Copie d\'un saut : la date copiée est celle du saut original (et non la date du jour)'**
  String get changelog091fixed1;

  /// No description provided for @changelog090date.
  ///
  /// In fr, this message translates to:
  /// **'21 mai 2026'**
  String get changelog090date;

  /// No description provided for @changelog090added1.
  ///
  /// In fr, this message translates to:
  /// **'Liens utiles personnalisés avec ouverture dans le navigateur'**
  String get changelog090added1;

  /// No description provided for @changelog090added2.
  ///
  /// In fr, this message translates to:
  /// **'Onglet \"Liens utiles\" dans l\'écran Listes'**
  String get changelog090added2;

  /// No description provided for @changelog090added3.
  ///
  /// In fr, this message translates to:
  /// **'Section Actifs / Archivés dans la liste des équipements'**
  String get changelog090added3;

  /// No description provided for @changelog090added4.
  ///
  /// In fr, this message translates to:
  /// **'Écran Info & Aide localisé FR / EN'**
  String get changelog090added4;

  /// No description provided for @changelog090added5.
  ///
  /// In fr, this message translates to:
  /// **'Pagination des sauts pour les grands carnets (10 000+ sauts)'**
  String get changelog090added5;

  /// No description provided for @changelog090added6.
  ///
  /// In fr, this message translates to:
  /// **'Import CSV optimisé : cache mémoire, transaction unique'**
  String get changelog090added6;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
