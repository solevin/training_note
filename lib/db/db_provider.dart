import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  factory DBProvider() => _instance;
  DBProvider._internal();
  static final DBProvider _instance = DBProvider._internal();

  Database? _database;
  String databaseName = 'myDatabase.db';
  bool isInitDatabase = false;

  Future<Database?> get database async {
    if (_database != null && !isInitDatabase) {
      return _database;
    } else {
      return _database = await initDB();
    }
  }

  Future<Database> initDB() async {
    final path = join(
      await getDatabasesPath(),
      databaseName,
    );
    if (isInitDatabase) {
      await deleteDatabase(path);
    }
    final result = await openDatabase(
      path,
      version: 1,
      onCreate: _initTable,
    );
    return result;
  }

  void _initTable(Database database, int version) {
    database.execute("""
            CREATE TABLE TrainingLog
              (
                id INTEGER PRIMARY KEY,
                date TEXT,
                ballQuantity INTEGER,
                memo TEXT
              )
            """);
  }
}
