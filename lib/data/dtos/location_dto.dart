import '../../model/location/location.dart';

class LocationDto {
  static const String idKey = 'id';
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String addressKey = 'address';
  static const String cityKey = 'city';

  static Location fromJson(String id, Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[latitudeKey] is num);
    assert(json[longitudeKey] is num);

    return Location(
      id: json[idKey],
      latitude: (json[latitudeKey] as num).toDouble(),
      longitude: (json[longitudeKey] as num).toDouble(),
      address: json[addressKey],
      city: json[cityKey],
    );
  }

  /// Convert Location to JSON
  static Map<String, dynamic> toJson(Location location) {
    return {
      idKey: location.id,
      latitudeKey: location.latitude,
      longitudeKey: location.longitude,
      addressKey: location.address,
      cityKey: location.city,
    };
  }
}
