import 'package:training_note/db/constants.dart';
import 'package:training_note/db/db_provider.dart';
import 'package:training_note/db/training_log.dart';

class TrainingLogDao {
  final DBProvider _dbProvider = DBProvider();

  Future<int> create(TrainingLog log) async {
    final db = await _dbProvider.database;
    final result = await db!.insert(tableNameTrainingLog, log.toMapExceptId());
    return result;
  }

  Future<List<TrainingLog>> findAll() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTrainingLog);
    final logs = List.generate(result.length, (i) {
      return TrainingLog.fromMap(result[i]);
    });
    return logs;
  }

  Future<TrainingLog> findById(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameTrainingLog, where: 'id=?', whereArgs: [id]);
    final log = TrainingLog.fromMap(result[0]);
    return log;
  }

  Future<List<int>> findByYear(int year) async {
    final db = await _dbProvider.database;
    final result = await db!
        .query(tableNameTrainingLog, where: 'year=?', whereArgs: [year]);
    var eachDateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachDateList.add(result[i]['id'] as int);
    }
    return eachDateList;
  }

  Future<List<int>> findByMonth(int year, int month) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTrainingLog,
        where: 'year=? and month=?', whereArgs: [year, month]);
    var eachDateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachDateList.add(result[i]['id'] as int);
    }
    return eachDateList;
  }

  Future<List<int>> findByDay(int year, int month, int day) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTrainingLog,
        where: 'year=? and month=? and day=?', whereArgs: [year, month, day]);
    var eachDateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachDateList.add(result[i]['id'] as int);
    }
    return eachDateList;
  }

  Future<List<int>> findGame() async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameTrainingLog, where: 'game=?', whereArgs: [1]);
    var eachDateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachDateList.add(result[i]['id'] as int);
    }
    return eachDateList;
  }

  Future<int> update(int id, TrainingLog log) async {
    final db = await _dbProvider.database;
    final result = await db!.update(
      tableNameTrainingLog,
      log.toMapExceptId(),
      where: 'id=?',
      whereArgs: [id],
    );
    return result;
  }
}
