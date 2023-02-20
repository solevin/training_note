import 'package:training_note/db/constants.dart';
import 'package:training_note/db/db_provider.dart';
import 'package:training_note/db/media.dart';

class MediaDao {
  final DBProvider _dbProvider = DBProvider();

  Future<int> create(Media target) async {
    final db = await _dbProvider.database;
    final result = await db!.insert(tableNameMedia, target.toMapExceptId());
    return result;
  }

  Future<List<Media>> findAll() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameMedia);
    final targets = List.generate(result.length, (i) {
      return Media.fromMap(result[i]);
    });
    return targets;
  }

  Future<List<int>> findAllIds() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameMedia);
    final targetIds = <int>[];
    for (int i = 0; i < result.length; i++) {
      targetIds.add(result[i]['id'] as int);
    }
    return targetIds;
  }

  Future<Media> findById(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameMedia, where: 'id=?', whereArgs: [id]);
    final target = Media.fromMap(result[0]);
    return target;
  }

  Future<List<int>> findByDate(int year, int month, int day) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameMedia,
        where: 'year=? and month=? and day=?', whereArgs: [year, month, day]);
    var dateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      dateList.add(result[i]['id'] as int);
    }
    return dateList;
  }

  Future<List<int>> findByYear(int year) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameMedia, where: 'year=?', whereArgs: [year]);
    var dateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      dateList.add(result[i]['id'] as int);
    }
    return dateList;
  }

  Future<List<int>> findByMonth(int year, int month) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameMedia,
        where: 'year=? and month=?', whereArgs: [year, month]);
    var dateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      dateList.add(result[i]['id'] as int);
    }
    return dateList;
  }

  Future<int> update(int id, Media target) async {
    final db = await _dbProvider.database;
    final result = await db!.update(
      tableNameMedia,
      target.toMapExceptId(),
      where: 'id=?',
      whereArgs: [id],
    );
    return result;
  }
}
