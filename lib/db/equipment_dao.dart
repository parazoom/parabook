import 'package:sqflite/sqflite.dart';
import '../models/equipment.dart';
import 'database.dart';

class EquipmentDao {
  Future<Database> get _db => AppDatabase.instance;

  Future<List<Equipment>> getByType(EquipmentType type) async {
    final db = await _db;
    final rows = await db.query('equipment',
        where: 'type = ?', whereArgs: [type.name], orderBy: 'name ASC');
    return rows.map(Equipment.fromMap).toList();
  }

  Future<Equipment?> getDefault(EquipmentType type) async {
    final db = await _db;
    final rows = await db.query('equipment',
        where: 'type = ? AND is_default = 1', whereArgs: [type.name], limit: 1);
    return rows.isEmpty ? null : Equipment.fromMap(rows.first);
  }

  Future<int> insert(Equipment e) async {
    final db = await _db;
    if (e.isDefault) {
      await db.update('equipment', {'is_default': 0},
          where: 'type = ?', whereArgs: [e.type.name]);
    }
    return db.insert('equipment', e.toMap()..remove('id'));
  }

  Future<void> update(Equipment e) async {
    final db = await _db;
    if (e.isDefault) {
      await db.update('equipment', {'is_default': 0},
          where: 'type = ?', whereArgs: [e.type.name]);
    }
    await db.update('equipment', e.toMap(), where: 'id = ?', whereArgs: [e.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('equipment', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Equipment>> getActiveReminders() async {
    final db = await _db;
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 30));
    final rows = await db.query('equipment',
        where: 'reminder_date IS NOT NULL AND reminder_date <= ?',
        whereArgs: [soon.toIso8601String()]);
    return rows.map(Equipment.fromMap).toList();
  }

  Future<int> countJumpsForEquipment(int id, String col) async {
    final db = await _db;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as c FROM jumps WHERE $col = ?', [id]);
    return result.first['c'] as int;
  }
}
