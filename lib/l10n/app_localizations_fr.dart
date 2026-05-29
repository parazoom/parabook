// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ParaBook';

  @override
  String get tabSummary => 'Résumé';

  @override
  String get tabJumps => 'Sauts';

  @override
  String get tabStats => 'Totaux';

  @override
  String get tabLists => 'Listes';

  @override
  String get tabActions => 'Actions';

  @override
  String get totalJumps => 'Total des sauts';

  @override
  String get cutaways => 'Libérations';

  @override
  String get dropZones => 'Zones de saut';

  @override
  String get countries => 'Pays';

  @override
  String get lastJump => 'Dernier saut';

  @override
  String get last30Days => '30 derniers jours';

  @override
  String get last12Months => '12 derniers mois';

  @override
  String get addJump => 'Ajouter un saut';

  @override
  String get copyLastJump => 'Copier le dernier saut';

  @override
  String get jumpNumber => 'Saut n°';

  @override
  String get date => 'Date';

  @override
  String get dropZone => 'Zone de saut';

  @override
  String get aircraft => 'Aéronef';

  @override
  String get canopy => 'Voile';

  @override
  String get bag => 'Sac';

  @override
  String get suit => 'Combinaison';

  @override
  String get jumpType => 'Type de saut';

  @override
  String get cutaway => 'Libération';

  @override
  String get notes => 'Notes';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get name => 'Nom';

  @override
  String get country => 'Pays';

  @override
  String get isDefault => 'Défaut';

  @override
  String get jumpsBefore => 'Sauts précédents';

  @override
  String get isArchived => 'Archivé';

  @override
  String get reminderDate => 'Date de rappel';

  @override
  String get equipment => 'Équipements';

  @override
  String get active => 'Actifs';

  @override
  String get archived => 'Archivés';

  @override
  String get byDropZone => 'Par zone de saut';

  @override
  String get byAircraft => 'Par aéronef';

  @override
  String get byEquipment => 'Par équipement';

  @override
  String get byJumpType => 'Par type de saut';

  @override
  String get byYear => 'Par année';

  @override
  String get byCountry => 'Par pays';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get exportShare => 'Partager';

  @override
  String get exportFile => 'Exporter en fichier';

  @override
  String get exportEmailSubject => 'ParaBook — Export du logbook';

  @override
  String get exportEmailBody =>
      'Voici l\'export de mon logbook ParaBook (fichier CSV) en pièce jointe.';

  @override
  String exportSaved(String path) {
    return 'Enregistré : $path';
  }

  @override
  String get exportCancelled => 'Export annulé';

  @override
  String get importCsv => 'Importer un CSV';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get backgroundColor => 'Couleur de fond';

  @override
  String get primaryColor => 'Couleur principale';

  @override
  String get textColor => 'Couleur du texte';

  @override
  String get defaults => 'Défauts';

  @override
  String get info => 'Infos';

  @override
  String get help => 'Aide';

  @override
  String get contactDeveloper => 'Contacter le développeur';

  @override
  String get reminderSoon => 'Rappel dans moins d\'un mois';

  @override
  String get reminderOverdue => 'Rappel dépassé';

  @override
  String get confirmDelete => 'Supprimer cet élément ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get noJumps => 'Aucun saut enregistré';

  @override
  String get num => 'N°';

  @override
  String get location => 'Lieu';

  @override
  String get type => 'Type';

  @override
  String get emailAddress => 'Adresse email';

  @override
  String get bags => 'Sacs';

  @override
  String get canopies => 'Voiles';

  @override
  String get suits => 'Combinaisons';

  @override
  String get jumpTypes => 'Types de saut';

  @override
  String get aircraftList => 'Aéronefs';

  @override
  String get addDropZone => 'Ajouter une DZ';

  @override
  String get addEquipment => 'Ajouter un équipement';

  @override
  String get addJumpType => 'Ajouter un type de saut';

  @override
  String get addAircraft => 'Ajouter un aéronef';

  @override
  String get editJump => 'Modifier le saut';

  @override
  String get jumps => 'sauts';

  @override
  String get defaultsDescription => 'Éléments cochés comme défaut';

  @override
  String get resetTheme => 'Réinitialiser le thème';

  @override
  String get infoAndHelp => 'Info & Aide';

  @override
  String get changelog => 'Nouveautés';

  @override
  String get about => 'À propos';

  @override
  String get aboutText =>
      'Cette application est une copie de Skydive Logbook, qui n\'était plus maintenue, avec quelques changements afin de coller avec mes besoins.\n\nSi vous avez des idées d\'amélioration, elles sont les bienvenues — utilisez le formulaire de contact pour ça.\n\nDéveloppé par Ludo PARAZOOM.';

  @override
  String get helpImportCsvTitle => 'Import CSV';

  @override
  String get helpCsvFormat => 'Le fichier CSV doit avoir le format suivant :';

  @override
  String get helpCsvColumns =>
      'Num, Date, Type, Drop Zone, Pays,\nAéronef, Sac, Voile, Combinaison,\nLibération, Notes';

  @override
  String get helpCsvDetails =>
      '• Les colonnes doivent être séparées par des virgules.\n• La date est au format AAAA-MM-JJ ou JJ/MM/AAAA.\n• La colonne Libération accepte : Oui, Yes ou 1.\n• Pour créer un fichier CSV, utilisez un tableur :\n  Google Sheets, LibreOffice Calc ou Excel,\n  puis exportez en format « CSV (séparateur virgule) ».';

  @override
  String get helpUsage => 'Utilisation';

  @override
  String get helpSummaryTitle => 'Résumé';

  @override
  String get helpSummaryText =>
      'La page d\'accueil affiche vos statistiques globales : total de sauts, libérations, zones de saut visitées, pays, dernier saut, et activité sur les 30 derniers jours et les 12 derniers mois. Si vous avez des sauts effectués avant l\'application, renseignez-les dans Paramètres application → \"Sauts avant l\'application\". Les liens utiles et vos informations de licence s\'affichent également ici.';

  @override
  String get helpJumpsTitle => 'Sauts';

  @override
  String get helpJumpsText =>
      'Liste de tous vos sauts, du plus récent au plus ancien. Appuyez sur un saut pour le consulter ou le modifier. Le bouton + ajoute un nouveau saut. Le bouton copie duplique le dernier saut enregistré (pratique pour des sauts répétitifs sur la même DZ avec le même matériel).';

  @override
  String get helpStatsTitle => 'Stats';

  @override
  String get helpStatsText =>
      'Visualisez la répartition de vos sauts par zone de saut, aéronef, équipement (sac, voile, combinaison), type de saut et année. Les barres sont proportionnelles à l\'entrée avec le plus grand nombre de sauts. Les sauts précédents (champ \"Sauts avant\" de chaque entrée) sont inclus dans les totaux.';

  @override
  String get helpListsTitle => 'Listes';

  @override
  String get helpListsText =>
      'Gérez vos référentiels : équipements (sac, voile, combinaison), zones de saut, types de saut, aéronefs et liens utiles. Pour chaque entrée, vous pouvez définir une valeur par défaut (pré-sélectionnée à la création d\'un saut) et renseigner des \"sauts précédents\" pour comptabiliser l\'usage antérieur à l\'application. Les équipements peuvent être archivés pour ne plus apparaître lors des saisies.';

  @override
  String get helpActionsTitle => 'Actions';

  @override
  String get helpActionsText =>
      'Importez vos anciens sauts depuis un fichier CSV (voir la section Import CSV ci-dessus). Exportez votre carnet par e-mail ou en fichier local. Accédez aux paramètres de l\'application (thème, langue, e-mail) et aux paramètres parachutiste (licence, infos). Contactez le développeur depuis cette page.';

  @override
  String get changelogAdded => 'Ajouté';

  @override
  String get changelogFixed => 'Corrigé';

  @override
  String get changelog100date => '29 mai 2026';

  @override
  String get changelog100note =>
      'Première publication publique sur Google Play.';

  @override
  String get changelog100fixedShare =>
      '« Exporter par email » devient « Partager » : envoyez votre export CSV vers n\'importe quelle app (messagerie, mail, cloud…)';

  @override
  String get changelog100fixedSave =>
      'L\'export en fichier permet désormais d\'enregistrer le CSV dans le dossier Téléchargements';

  @override
  String get changelog093date => '28 mai 2026';

  @override
  String get changelog093added0 => 'Nouvelle icône de l\'application';

  @override
  String get changelog093addedLandscape =>
      'Liste des sauts en mode paysage : colonnes date/type, aéronef, équipements et notes';

  @override
  String get changelog093addedCutaway =>
      'Icône parachute dans la liste des sauts quand une libération est enregistrée';

  @override
  String get changelog093added1 =>
      'Onglet \"Par pays\" dans les Totaux : répartition des sauts par pays';

  @override
  String get changelog093added2 => 'Section \"Nouveautés\" dans Info & Aide';

  @override
  String get changelog093fixedNavBar =>
      'Barre de navigation Android chevauchant le contenu sur tous les écrans (portrait & paysage)';

  @override
  String get changelog093fixed1 =>
      'Orthographe \"Béni Mellal\" (anciennement \"Beni Melal\")';

  @override
  String get changelog093fixed2 =>
      'Couleur du texte personnalisée non appliquée partout (titres, sous-titres, labels, dropdowns)';

  @override
  String get changelog093fixed3 =>
      'Langue par défaut : Anglais (au lieu du Français)';

  @override
  String get changelog092date => '27 mai 2026';

  @override
  String get changelog092fixed1 =>
      'Formulaires : boutons Enregistrer / Annuler / Supprimer masqués derrière la barre de navigation Android';

  @override
  String get changelog092fixed2 =>
      'Formulaires : contenu trop long restait hors écran sans scroll possible — corrigé';

  @override
  String get changelog092fixed3 =>
      'android:label affiché correctement \"ParaBook\" dans le lanceur Android';

  @override
  String get changelog091date => '27 mai 2026';

  @override
  String get changelog091added1 =>
      'Archivage des zones de saut, aéronefs et types de saut';

  @override
  String get changelog091added2 =>
      'Les éléments archivés n\'apparaissent plus dans les menus déroulants';

  @override
  String get changelog091added3 =>
      'Séparation Actifs / Archivés dans les listes';

  @override
  String get changelog091fixed1 =>
      'Copie d\'un saut : la date copiée est celle du saut original (et non la date du jour)';

  @override
  String get changelog090date => '21 mai 2026';

  @override
  String get changelog090added1 =>
      'Liens utiles personnalisés avec ouverture dans le navigateur';

  @override
  String get changelog090added2 =>
      'Onglet \"Liens utiles\" dans l\'écran Listes';

  @override
  String get changelog090added3 =>
      'Section Actifs / Archivés dans la liste des équipements';

  @override
  String get changelog090added4 => 'Écran Info & Aide localisé FR / EN';

  @override
  String get changelog090added5 =>
      'Pagination des sauts pour les grands carnets (10 000+ sauts)';

  @override
  String get changelog090added6 =>
      'Import CSV optimisé : cache mémoire, transaction unique';
}
