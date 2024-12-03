import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime lastSearched;

  const Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.lastSearched,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'last_searched': lastSearched.toIso8601String(),
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      lastSearched: DateTime.parse(map['last_searched']),
    );
  }

  @override
  List<Object> get props => [id, address, latitude, longitude, lastSearched];
}
