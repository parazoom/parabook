import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get instance async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    // Sur le web : SQLite compilé en WASM, persisté dans le navigateur (IndexedDB).
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return databaseFactory.openDatabase(
        'parabook.db',
        options: OpenDatabaseOptions(
          version: 6,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
        ),
      );
    }
    final path = join(await getDatabasesPath(), 'parabook.db');
    return openDatabase(path, version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jumps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        num INTEGER NOT NULL,
        date TEXT NOT NULL,
        jump_type_id INTEGER,
        drop_zone_id INTEGER,
        aircraft_id INTEGER,
        bag_id INTEGER,
        canopy_id INTEGER,
        suit_id INTEGER,
        cutaway INTEGER NOT NULL DEFAULT 0,
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE drop_zones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        country TEXT NOT NULL DEFAULT '',
        is_default INTEGER NOT NULL DEFAULT 0,
        is_archived INTEGER NOT NULL DEFAULT 0,
        jumps_before INTEGER NOT NULL DEFAULT 0,
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE equipment (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        is_archived INTEGER NOT NULL DEFAULT 0,
        jumps_before INTEGER NOT NULL DEFAULT 0,
        reminder_date TEXT,
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE jump_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        is_archived INTEGER NOT NULL DEFAULT 0,
        jumps_before INTEGER NOT NULL DEFAULT 0,
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE aircraft (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        is_archived INTEGER NOT NULL DEFAULT 0,
        jumps_before INTEGER NOT NULL DEFAULT 0,
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');

    await _createUsefulLinks(db);
    await _seedDefaults(db);
    await _createIndexes(db);
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) await _createUsefulLinks(db);
    if (oldVersion < 3) await _seedDefaults(db);
    if (oldVersion < 4) await _createIndexes(db);
    if (oldVersion < 5) await _addIsArchivedColumns(db);
    if (oldVersion < 6) await _fixBeniMellal(db);
  }

  static Future<void> _createIndexes(Database db) async {
    await db.execute('CREATE INDEX IF NOT EXISTS idx_jumps_num ON jumps(num DESC)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_jumps_dz ON jumps(drop_zone_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_jumps_type ON jumps(jump_type_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_jumps_bag ON jumps(bag_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_jumps_canopy ON jumps(canopy_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_jumps_suit ON jumps(suit_id)');
  }

  static Future<void> _seedDefaults(Database db) async {
    for (final name in ['Epicene Pro', 'Sabre 2 - 129']) {
      await db.rawInsert(
        "INSERT INTO equipment (name, type, is_default, is_archived, jumps_before, notes) "
        "SELECT ?, 'canopy', 0, 0, 0, '' "
        "WHERE NOT EXISTS (SELECT 1 FROM equipment WHERE name = ? AND type = 'canopy')",
        [name, name],
      );
    }
    for (final name in ['Atom', 'Sac de loc']) {
      await db.rawInsert(
        "INSERT INTO equipment (name, type, is_default, is_archived, jumps_before, notes) "
        "SELECT ?, 'bag', 0, 0, 0, '' "
        "WHERE NOT EXISTS (SELECT 1 FROM equipment WHERE name = ? AND type = 'bag')",
        [name, name],
      );
    }
    for (final name in ['Freak 5', 'ATC 5']) {
      await db.rawInsert(
        "INSERT INTO equipment (name, type, is_default, is_archived, jumps_before, notes) "
        "SELECT ?, 'suit', 0, 0, 0, '' "
        "WHERE NOT EXISTS (SELECT 1 FROM equipment WHERE name = ? AND type = 'suit')",
        [name, name],
      );
    }
    for (final dz in [
      ['Fretoy', 'France'],
      ['Bouloc', 'France'],
      ['Morsel', 'Belgique'],
      ['Béni Mellal', 'Maroc'],
    ]) {
      await db.rawInsert(
        "INSERT INTO drop_zones (name, country, is_default, jumps_before, notes) "
        "SELECT ?, ?, 0, 0, '' "
        "WHERE NOT EXISTS (SELECT 1 FROM drop_zones WHERE name = ?)",
        [dz[0], dz[1], dz[0]],
      );
    }
    for (final name in ['Freefly', 'Wingsuit', 'Psv']) {
      await db.rawInsert(
        "INSERT INTO jump_types (name, is_default, jumps_before, notes) "
        "SELECT ?, 0, 0, '' "
        "WHERE NOT EXISTS (SELECT 1 FROM jump_types WHERE name = ?)",
        [name, name],
      );
    }
    for (final name in ['Beech', 'Caravan', 'Pilatus']) {
      await db.rawInsert(
        "INSERT INTO aircraft (name, is_default, jumps_before, notes) "
        "SELECT ?, 0, 0, '' "
        "WHERE NOT EXISTS (SELECT 1 FROM aircraft WHERE name = ?)",
        [name, name],
      );
    }
  }

  static Future<void> _fixBeniMellal(Database db) async {
    await db.execute("UPDATE drop_zones SET name = 'Béni Mellal' WHERE name = 'Beni Melal'");
  }

  static Future<void> _addIsArchivedColumns(Database db) async {
    await db.execute('ALTER TABLE drop_zones ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
    await db.execute('ALTER TABLE jump_types ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
    await db.execute('ALTER TABLE aircraft ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
  }

  static Future<void> _createUsefulLinks(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS useful_links (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        url TEXT NOT NULL
      )
    ''');
  }
}
