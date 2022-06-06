import 'package:seed/models/seed.dart';

import 'dao.dart';

class SeedDao implements Dao<Seed> {
  final tableName = 'seeds';
  final columnId = 'id';
  final columnName = 'name';
  final columnManufacturer = 'manufacturer';
  final _columnManufacturedAt = 'manufacturedAt';
  final _columnExpiresIn = 'expiresIn';
  final _columnCreatedAt = 'createdAt';
  final columnSynchronized = 'synchronized';

  @override
  String get createTableQuery => 'CREATE TABLE seeds('
      '$columnId TEXT PRIMARY KEY, '
      '$columnName TEXT NOT NULL, '
      '$columnManufacturer TEXT NOT NULL, '
      '$_columnManufacturedAt TEXT NOT NULL, '
      '$_columnExpiresIn TEXT NOT NULL, '
      '$_columnCreatedAt TEXT NOT NULL, '
      '$columnSynchronized INTEGER NOT NULL'
      ')';

  @override
  Seed fromMap(Map<String, dynamic> query) {
    return Seed(
        id: query[columnId],
        name: query[columnName],
        manufacturer: query[columnManufacturer],
        manufacturedAt: query[_columnManufacturedAt],
        createdAt: query[_columnCreatedAt],
        expiresIn: query[_columnExpiresIn],
        synchronized: query[columnSynchronized]);
  }

  @override
  Map<String, dynamic> toMap(Seed seed) {
    return <String, dynamic>{
      columnId: seed.id,
      columnName: seed.name,
      columnManufacturer: seed.manufacturer,
      _columnManufacturedAt: seed.manufacturedAt,
      _columnExpiresIn: seed.expiresIn,
      _columnCreatedAt: seed.createdAt,
      columnSynchronized: seed.synchronized,
    };
  }

  @override
  List<Seed> fromList(List<Map<String, dynamic>> query) {
    List<Seed> seeds = [];
    for (Map<String, dynamic> map in query) {
      seeds.add(fromMap(map));
    }
    return seeds;
  }
}
