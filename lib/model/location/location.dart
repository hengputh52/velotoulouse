import 'dart:math';

class Location {
  final String id;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;

  const Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
  });

}
