import 'package:sqflite/sqflite.dart';
import '../models/useful_link.dart';
import 'database.dart';

class UsefulLinksDao {
  Future<Database> get _db => AppDatabase.instance;

  Future<List<UsefulLink>> getAll() async {
    final db = await _db;
    final rows = await db.query('useful_links', orderBy: 'title ASC');
    return rows.map(UsefulLink.fromMap).toList();
  }

  Future<int> insert(UsefulLink link) async {
    final db = await _db;
    return db.insert('useful_links', link.toMap()..remove('id'));
  }

  Future<void> update(UsefulLink link) async {
    final db = await _db;
    await db.update('useful_links', link.toMap(), where: 'id = ?', whereArgs: [link.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('useful_links', where: 'id = ?', whereArgs: [id]);
  }
}
