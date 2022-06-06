import 'package:path/path.dart';
import 'package:seed/database/seed_dao.dart';
import 'package:seed/database/user_dao.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final _instance = DatabaseProvider._internal();
  static DatabaseProvider get = _instance;
  bool isInitialized = false;
  late Database _db;

  DatabaseProvider._internal();

  Future<Database> db() async {
    if (!isInitialized) await _init();
    return _db;
  }

  Future<void> _init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'seeder_app.db');

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(SeedDao().createTableQuery);
      await db.execute(UserDao().createTableQuery);
    });
  }
}
