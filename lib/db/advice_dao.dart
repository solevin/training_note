import 'package:training_note/db/constants.dart';
import 'package:training_note/db/db_provider.dart';
import 'package:training_note/db/advice.dart';

class AdviceDao {
  final DBProvider _dbProvider = DBProvider();

  Future<int> create(Advice target) async {
    final db = await _dbProvider.database;
    final result = await db!.insert(tableNameAdvice, target.toMapExceptId());
    return result;
  }

  Future<List<Advice>> findAll() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameAdvice);
    final targets = List.generate(result.length, (i) {
      return Advice.fromMap(result[i]);
    });
    return targets;
  }

  Future<List<int>> findAllIds() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameAdvice);
    final targetIds = <int>[];
    for (int i = 0; i < result.length; i++) {
      targetIds.add(result[i]['id'] as int);
    }
    return targetIds;
  }

  Future<Advice> findById(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameAdvice, where: 'id=?', whereArgs: [id]);
    final target = Advice.fromMap(result[0]);
    return target;
  }

  Future<List<int>> findByDate(String date) async {
    final db = await _dbProvider.database;
    final result =
        await db!.query(tableNameAdvice, where: 'date=?', whereArgs: [date]);
    var dateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      dateList.add(result[i]['id'] as int);
    }
    return dateList;
  }

  Future<List<int>> findIsAchieved(int isAchieved) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameAdvice, where: 'isAchieved=1');
    var achievedList = <int>[];
    for (var i = 0; i < result.length; i++) {
      achievedList.add(result[i]['id'] as int);
    }
    return achievedList;
  }

  Future<List<int>> findnotAchieved(int isAchieved) async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameAdvice, where: 'isAchieved=0');
    var notAchievedList = <int>[];
    for (var i = 0; i < result.length; i++) {
      notAchievedList.add(result[i]['id'] as int);
    }
    return notAchievedList;
  }

  Future<int> update(int id, Advice target) async {
    final db = await _dbProvider.database;
    final result = await db!.update(
      tableNameAdvice,
      target.toMapExceptId(),
      where: 'id=?',
      whereArgs: [id],
    );
    return result;
  }
}
