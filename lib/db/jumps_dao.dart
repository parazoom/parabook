import 'package:sqflite/sqflite.dart';
import '../models/jump.dart';
import 'database.dart';

class JumpsDao {
  Future<Database> get _db => AppDatabase.instance;

  Future<List<Jump>> getAll() async {
    final db = await _db;
    final rows = await db.query('jumps', orderBy: 'num DESC');
    return rows.map(Jump.fromMap).toList();
  }

  Future<List<Jump>> getPage(int limit, {int? beforeNum}) async {
    final db = await _db;
    final rows = beforeNum == null
        ? await db.query('jumps', orderBy: 'num DESC', limit: limit)
        : await db.rawQuery(
            'SELECT * FROM jumps WHERE num < ? ORDER BY num DESC LIMIT ?',
            [beforeNum, limit],
          );
    return rows.map(Jump.fromMap).toList();
  }

  Future<Jump?> getLast() async {
    final db = await _db;
    final rows = await db.query('jumps', orderBy: 'num DESC', limit: 1);
    return rows.isEmpty ? null : Jump.fromMap(rows.first);
  }

  Future<int> getNextNum() async {
    final last = await getLast();
    return (last?.num ?? 0) + 1;
  }

  Future<int> insert(Jump jump) async {
    final db = await _db;
    return db.insert('jumps', jump.toMap()..remove('id'));
  }

  Future<void> update(Jump jump) async {
    final db = await _db;
    await db.update('jumps', jump.toMap(), where: 'id = ?', whereArgs: [jump.id]);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('jumps', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countAll() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM jumps');
    return result.first['c'] as int;
  }

  Future<int> countCutaways() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM jumps WHERE cutaway = 1');
    return result.first['c'] as int;
  }

  Future<int> countLast30Days() async {
    final db = await _db;
    final since = DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM jumps WHERE date >= ?', [since]);
    return result.first['c'] as int;
  }

  Future<int> countLast12Months() async {
    final db = await _db;
    final since = DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day).toIso8601String();
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM jumps WHERE date >= ?', [since]);
    return result.first['c'] as int;
  }

  Future<List<Map<String, dynamic>>> groupByDropZone() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT dz.name, dz.country, dz.is_default, (COUNT(j.id) + COALESCE(dz.jumps_before, 0)) as count
      FROM drop_zones dz LEFT JOIN jumps j ON j.drop_zone_id = dz.id
      GROUP BY dz.id ORDER BY count DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> groupByAircraft() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT a.name, a.is_default, (COUNT(j.id) + COALESCE(a.jumps_before, 0)) as count
      FROM aircraft a LEFT JOIN jumps j ON j.aircraft_id = a.id
      GROUP BY a.id ORDER BY count DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> groupByJumpType() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT jt.name, jt.is_default, (COUNT(j.id) + COALESCE(jt.jumps_before, 0)) as count
      FROM jump_types jt LEFT JOIN jumps j ON j.jump_type_id = jt.id
      GROUP BY jt.id ORDER BY count DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> groupByYear() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT strftime('%Y', date) as year, COUNT(*) as count
      FROM jumps GROUP BY year ORDER BY year DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> groupByCountry() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT country as name, SUM(dz_total) as count
      FROM (
        SELECT dz.country, (COUNT(j.id) + COALESCE(dz.jumps_before, 0)) as dz_total
        FROM drop_zones dz LEFT JOIN jumps j ON j.drop_zone_id = dz.id
        WHERE dz.country IS NOT NULL AND dz.country != ''
        GROUP BY dz.id
      ) sub
      GROUP BY country
      ORDER BY count DESC
    ''');
  }

  Future<int> countDistinctDropZones() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(DISTINCT drop_zone_id) as c FROM jumps');
    return result.first['c'] as int;
  }

  Future<int> countDistinctCountries() async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT dz.country) as c
      FROM jumps j JOIN drop_zones dz ON j.drop_zone_id = dz.id
      WHERE dz.country != ''
    ''');
    return result.first['c'] as int;
  }

  Future<List<Map<String, dynamic>>> groupByEquipment(String equipmentType) async {
    final db = await _db;
    final col = equipmentType == 'bag' ? 'bag_id' : equipmentType == 'canopy' ? 'canopy_id' : 'suit_id';
    return db.rawQuery('''
      SELECT e.name, e.is_default, e.is_archived, (COUNT(j.id) + COALESCE(e.jumps_before, 0)) as count
      FROM equipment e LEFT JOIN jumps j ON j.$col = e.id
      WHERE e.type = ?
      GROUP BY e.id ORDER BY e.is_archived ASC, count DESC
    ''', [equipmentType]);
  }
}
