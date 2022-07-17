import 'package:training_note/db/constants.dart';
import 'package:training_note/db/db_provider.dart';
import 'package:training_note/db/target_log.dart';

class TargetLogDao {
  final DBProvider _dbProvider = DBProvider();

  Future<int> create(TargetLog target) async {
    final db = await _dbProvider.database;
    final result = await db!.insert(tableNameTargetLog, target.toMapExceptId());
    return result;
  }

  Future<List<TargetLog>> findAll() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTargetLog);
    final targets = List.generate(result.length, (i) {
      return TargetLog.fromMap(result[i]);
    });
    return targets;
  }

  Future<List<int>> findAllIds() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTargetLog);
    final targetIds = <int>[];
    for (int i = 0; i < result.length; i++) {
      targetIds.add(result[i]['id'] as int);
    }
    return targetIds;
  }

  Future<TargetLog> findById(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameTargetLog, where: 'id=?', whereArgs: [id]);
    final target = TargetLog.fromMap(result[0]);
    return target;
  }

  Future<List<int>> findByDeadLine(String deadLine) async {
    final db = await _dbProvider.database;
    final result = await db!
        .query(tableNameTargetLog, where: 'deadLine=?', whereArgs: [deadLine]);
    var deadLineList = <int>[];
    for (var i = 0; i < result.length; i++) {
      deadLineList.add(result[i]['id'] as int);
    }
    return deadLineList;
  }

  Future<List<int>> findIsAchieved(int isAchieved) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTargetLog, where: 'isAchieved=1');
    var achievedList = <int>[];
    for (var i = 0; i < result.length; i++) {
      achievedList.add(result[i]['id'] as int);
    }
    return achievedList;
  }

  Future<List<int>> findnotAchieved(int isAchieved) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTargetLog, where: 'isAchieved=0');
    var notAchievedList = <int>[];
    for (var i = 0; i < result.length; i++) {
      notAchievedList.add(result[i]['id'] as int);
    }
    return notAchievedList;
  }

  Future<int> update(int id, TargetLog target) async {
    final db = await _dbProvider.database;
    final result = await db!.update(
      tableNameTargetLog,
      target.toMapExceptId(),
      where: 'id=?',
      whereArgs: [id],
    );
    return result;
  }
}
