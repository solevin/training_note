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
    final meat = TrainingLog.fromMap(result[0]);
    return meat;
  }

  Future<List<int>> findByDate(String date) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameTrainingLog, where: 'date=?', whereArgs: [date]);
    var eachDateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachDateList.add(result[i]['id'] as int);
    }
    return eachDateList;
  }

  Future<List<int>> findByKind(String kind) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameTrainingLog, where: 'kind=?', whereArgs: [kind]);
    var eachKindList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachKindList.add(result[i]['id'] as int);
    }
    return eachKindList;
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
