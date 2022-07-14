import 'package:training_note/db/constants.dart';
import 'package:training_note/db/db_provider.dart';
import 'package:training_note/db/target_log.dart';

class TargetLogDao {
  final DBProvider _dbProvider = DBProvider();

  Future<int> create(TargetLog count) async {
    final db = await _dbProvider.database;
    final result = await db!.insert(tableNameTargetLog, count.toMapExceptId());
    return result;
  }

  Future<List<TargetLog>> findAll() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameTargetLog);
    final counts = List.generate(result.length, (i) {
      return TargetLog.fromMap(result[i]);
    });
    return counts;
  }

  Future<TargetLog> findById(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameTargetLog, where: 'id=?', whereArgs: [id]);
    final count = TargetLog.fromMap(result[0]);
    return count;
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

  Future<int> update(int id, TargetLog count) async {
    final db = await _dbProvider.database;
    final result = await db!.update(
      tableNameTargetLog,
      count.toMapExceptId(),
      where: 'id=?',
      whereArgs: [id],
    );
    return result;
  }
}
