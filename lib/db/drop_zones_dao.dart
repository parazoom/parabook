import 'package:sqflite/sqflite.dart';
import '../models/drop_zone.dart';
import 'database.dart';

class DropZonesDao {
  Future<Database> get _db => AppDatabase.instance;

  Future<List<DropZone>> getAll() async {
    final db = await _db;
    final rows = await db.query('drop_zones', orderBy: 'name ASC');
    return rows.map(DropZone.fromMap).toList();
  }

  Future<DropZone?> getDefault() async {
    final db = await _db;
    final rows = await db.query('drop_zones', where: 'is_default = 1', limit: 1);
    return rows.isEmpty ? null : DropZone.fromMap(rows.first);
  }

  Future<int> insert(DropZone dz) async {
    final db = await _db;
    if (dz.isDefault) await db.update('drop_zones', {'is_default': 0});
    return db.insert('drop_zones', dz.toMap()..remove('id'));
  }

  Future<void> update(DropZone dz) async {
    final db = await _db;
    if (dz.isDefault) await db.update('drop_zones', {'is_default': 0});
    await db.update('drop_zones', dz.toMap(), where: 'id = ?', whereArgs: [dz.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('drop_zones', where: 'id = ?', whereArgs: [id]);
  }
}
