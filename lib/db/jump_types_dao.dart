import 'package:sqflite/sqflite.dart';
import '../models/jump_type.dart';
import 'database.dart';

class JumpTypesDao {
  Future<Database> get _db => AppDatabase.instance;

  Future<List<JumpType>> getAll() async {
    final db = await _db;
    final rows = await db.query('jump_types', orderBy: 'name ASC');
    return rows.map(JumpType.fromMap).toList();
  }

  Future<JumpType?> getDefault() async {
    final db = await _db;
    final rows = await db.query('jump_types', where: 'is_default = 1', limit: 1);
    return rows.isEmpty ? null : JumpType.fromMap(rows.first);
  }

  Future<int> insert(JumpType jt) async {
    final db = await _db;
    if (jt.isDefault) await db.update('jump_types', {'is_default': 0});
    return db.insert('jump_types', jt.toMap()..remove('id'));
  }

  Future<void> update(JumpType jt) async {
    final db = await _db;
    if (jt.isDefault) await db.update('jump_types', {'is_default': 0});
    await db.update('jump_types', jt.toMap(), where: 'id = ?', whereArgs: [jt.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('jump_types', where: 'id = ?', whereArgs: [id]);
  }
}
