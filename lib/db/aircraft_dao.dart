import 'package:sqflite/sqflite.dart';
import '../models/aircraft.dart';
import 'database.dart';

class AircraftDao {
  Future<Database> get _db => AppDatabase.instance;

  Future<List<Aircraft>> getAll() async {
    final db = await _db;
    final rows = await db.query('aircraft', orderBy: 'name ASC');
    return rows.map(Aircraft.fromMap).toList();
  }

  Future<Aircraft?> getDefault() async {
    final db = await _db;
    final rows = await db.query('aircraft', where: 'is_default = 1', limit: 1);
    return rows.isEmpty ? null : Aircraft.fromMap(rows.first);
  }

  Future<int> insert(Aircraft a) async {
    final db = await _db;
    if (a.isDefault) await db.update('aircraft', {'is_default': 0});
    return db.insert('aircraft', a.toMap()..remove('id'));
  }

  Future<void> update(Aircraft a) async {
    final db = await _db;
    if (a.isDefault) await db.update('aircraft', {'is_default': 0});
    await db.update('aircraft', a.toMap(), where: 'id = ?', whereArgs: [a.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('aircraft', where: 'id = ?', whereArgs: [id]);
  }
}
