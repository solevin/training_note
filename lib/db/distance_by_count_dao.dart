import 'package:training_note/db/constants.dart';
import 'package:training_note/db/db_provider.dart';
import 'package:training_note/db/distance_by_count.dart';

class DistanceByCountDao {
  final DBProvider _dbProvider = DBProvider();

  Future<int> create(DistanceByCount count) async {
    final db = await _dbProvider.database;
    final result =
        await db!.insert(tableNameDistanceByCount, count.toMapExceptId());
    return result;
  }

  Future<List<DistanceByCount>> findAll() async {
    final db = await _dbProvider.database;
    final result = await db!.query(tableNameDistanceByCount);
    final counts = List.generate(result.length, (i) {
      return DistanceByCount.fromMap(result[i]);
    });
    return counts;
  }

  Future<DistanceByCount> findById(int id) async {
    final db = await _dbProvider.database;
    final result = await db!
        .query(tableNameDistanceByCount, where: 'id=?', whereArgs: [id]);
    final count = DistanceByCount.fromMap(result[0]);
    return count;
  }

  Future<int> findByClub(String club) async {
    final db = await _dbProvider.database;
    final result = await db!
        .query(tableNameDistanceByCount, where: 'club=?', whereArgs: [club]);
    var eachDateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachDateList.add(result[i]['id'] as int);
    }
    return eachDateList[0];
  }

  Future<List<int>> findBykind(int kind) async {
    final db = await _dbProvider.database;
    final result = await db!
        .query(tableNameDistanceByCount, where: 'kind=?', whereArgs: [kind]);
    var eachDateList = <int>[];
    for (var i = 0; i < result.length; i++) {
      eachDateList.add(result[i]['id'] as int);
    }
    return eachDateList;
  }

  Future<int> update(int id, DistanceByCount count) async {
    final db = await _dbProvider.database;
    final result = await db!.update(
      tableNameDistanceByCount,
      count.toMapExceptId(),
      where: 'id=?',
      whereArgs: [id],
    );
    return result;
  }

  Future<void> initDistance() async {
    final find = await findAll();
    if (find.isEmpty) {
      final clubList = [
        ['1W', '3W', '4W', '5W', '7W', '9W'],
        ['3U', '4U', '5U', '6U', '7U'],
        ['3I', '4I', '5I', '6I', '7I', '8I', '9I'],
        ['PW', 'AW', 'SW', 'LW'],
      ];
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < clubList[i].length; j++) {
          final tmpDistance =
              DistanceByCount(club: clubList[i][j], kind: i, distance: 0);
          await create(tmpDistance);
        }
      }
    }
  }

  Future<void> updateAll(List<int> woodDistance, List<int> utDistance,
      List<int> ironDistance, List<int> wedgeDistance) async {
    final db = await _dbProvider.database;
    await db!.delete(tableNameDistanceByCount);
    final clubList = [
      ['1W', '3W', '4W', '5W', '7W', '9W'],
      ['3U', '4U', '5U', '6U', '7U'],
      ['3I', '4I', '5I', '6I', '7I', '8I', '9I'],
      ['PW', 'AW', 'SW', 'LW'],
    ];
    final distanceList = [
      woodDistance,
      utDistance,
      ironDistance,
      wedgeDistance
    ];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < clubList[i].length; j++) {
        final tmpDistance = DistanceByCount(
            club: clubList[i][j], kind: i, distance: distanceList[i][j]);
        await create(tmpDistance);
      }
    }
  }
}
