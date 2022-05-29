class DatabaseSeed {
  const DatabaseSeed(
      {required this.id,
      required this.name,
      required this.manufacturer,
      required this.manufacturedAt,
      required this.expiresIn,
      required this.synchronized});

  final String id;
  final String name;
  final String manufacturer;
  final String manufacturedAt;
  final String expiresIn;
  final int synchronized;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'manufacturedAt': manufacturedAt,
      'expiresIn': expiresIn,
      'synchronized': synchronized,
    };
  }

  @override
  String toString() {
    return """DatabaseSeed{
    id: $id, 
    name: $name, 
    manufacture: $manufacturer, 
    manufacturedAt: $manufacturedAt, 
    expiresIn: $expiresIn, 
    synchronized: $synchronized}""";
  }
}
