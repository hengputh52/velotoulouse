import 'package:velotoulouse/model/location/location.dart';


class LocationDto {
  final String id;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;

  const LocationDto({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
    };
  }

  Location toModel() {
    return Location(
      id: id,
      latitude: latitude,
      longitude: longitude,
      address: address,
      city: city,
    );
  }

  factory LocationDto.fromModel(Location model) {
    return LocationDto(
      id: model.id,
      latitude: model.latitude,
      longitude: model.longitude,
      address: model.address,
      city: model.city,
    );
  }
}
