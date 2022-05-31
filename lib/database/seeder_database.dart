import 'package:path/path.dart';
import 'package:seed/models/database_seed.dart';
import 'package:sqflite/sqflite.dart';

class SeederDatabase {
  Future<Database> getInstance() async {
    return openDatabase(
        join(
          await getDatabasesPath(),
          'seeder_databse.db',
        ), onCreate: (seedDatabase, version) {
      return seedDatabase.execute(
        'CREATE TABLE seeds('
        'id TEXT PRIMARY KEY, '
        'name TEXT, '
        'manufacturer TEXT, '
        'manufacturedAt TEXT, '
        'expiresIn TEXT, '
        'synchronized INTEGER'
        ')',
      );
    }, version: 1);
  }

  Future<void> insertSeed(DatabaseSeed databaseSeed) async {
    final db = await getInstance();

    await db.insert(
      'seeds',
      databaseSeed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DatabaseSeed>> getAllSeeds() async {
    final db = await getInstance();

    final List<Map<String, dynamic>> maps = await db.query('seeds');

    final list = List.generate(maps.length, (index) {
      return DatabaseSeed(
        id: maps[index]['id'],
        name: maps[index]['name'],
        manufacturer: maps[index]['manufacturer'],
        manufacturedAt: maps[index]['manufacturedAt'],
        expiresIn: maps[index]['expiresIn'],
        synchronized: maps[index]['synchronized'] as int ,
      );
    });


    return list;
  }

  Future<List<DatabaseSeed>> getDesynchronizedSeeds() async {
    final db = await getInstance();

    final List<Map<String, dynamic>> maps = await db.query(
      'seeds',
      where: 'synchronized = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (index) {
      return DatabaseSeed(
        id: maps[index]['id'],
        name: maps[index]['name'],
        manufacturer: maps[index]['manufacturer'],
        manufacturedAt: maps[index]['manufacturedAt'],
        expiresIn: maps[index]['expiresIn'],
        synchronized: maps[index]['synchronized'],
      );
    });
  }
}
