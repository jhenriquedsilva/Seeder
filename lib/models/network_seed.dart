import 'dart:convert';

class NetworkSeed {
  const NetworkSeed({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.manufacturedAt,
    required this.expiresIn,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String manufacturer;
  final String manufacturedAt;
  final String expiresIn;
  final String createdAt;

  String toJson(String userId) {
    return json.encode({
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'manufacturedAt': manufacturedAt,
      'expiresIn': expiresIn,
      'createdAt': createdAt,
      'userId': userId,
    });
  }

  factory NetworkSeed.fromJson(Map<String, dynamic> json) {
    return NetworkSeed(
      id: json['id'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      manufacturedAt: json['manufacturedAt'],
      expiresIn: json['expiresIn'],
      createdAt: json['createdAt'],
    );
  }

  @override
  String toString() {
    return '''NetworkSeed{
    id: $id, 
    name: $name, 
    manufacture: $manufacturer, 
    manufacturedAt: $manufacturedAt, 
    expiresIn: $expiresIn,
    createdAt: $createdAt}''';
  }
}