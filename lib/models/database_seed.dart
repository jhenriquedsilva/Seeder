class DatabaseSeed {
  const DatabaseSeed(
      {required this.id,
      required this.name,
      required this.manufacturer,
      required this.manufacturedAt,
      required this.expiresIn,
      required this.createdAt,
      required this.synchronized});

  final String id;
  final String name;
  final String manufacturer;
  final String manufacturedAt;
  final String expiresIn;
  final String createdAt;
  final int synchronized;

  factory DatabaseSeed.fromMap(Map<String, dynamic> map) {
    return DatabaseSeed(
      id: map['id'],
      name: map['name'],
      manufacturer: map['manufacturer'],
      manufacturedAt: map['manufacturedAt'],
      expiresIn: map['expiresIn'],
      createdAt: map['createdAt'],
      synchronized: map['synchronized'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'manufacturedAt': manufacturedAt,
      'expiresIn': expiresIn,
      'createdAt': createdAt,
      'synchronized': synchronized,
    };
  }

  @override
  String toString() {
    return '''DatabaseSeed{
    id: $id, 
    name: $name, 
    manufacture: $manufacturer, 
    manufacturedAt: $manufacturedAt, 
    expiresIn: $expiresIn,
    createdAt: $createdAt, 
    synchronized: $synchronized}''';
  }
}
