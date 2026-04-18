<<<<<<< Updated upstream
// import 'dart:math';

// class Location {
//   final String id;
//   final double latitude;
//   final double longitude;
//   final String? address;
//   final String? city;

//   const Location({
//     required this.id,
//     required this.latitude,
//     required this.longitude,
//     this.address,
//     this.city,
//   });

//   distanceTo(Location location) {}

//   @override
//   String toString() => 'Location($id, $latitude, $longitude)';
// }

// double distancetTo(Location other, double latitude, double longitude) {
//   const double R = 6371000;
//   final double lat1 = _rad(latitude);
//   final double lat2 = _rad(other.latitude);
//   final double deltaLat = _rad(other.latitude - latitude);
//   final double deltaLon = _rad(other.longitude - longitude);

//   final double a =
//       sin(deltaLat / 2) * sin(deltaLat / 2) +
//       cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
//   return R * 2 * atan2(sqrt(a), sqrt(1 - a));
// }

// double _rad(double degree) {
//   return degree * pi / 180;
// }
import 'dart:math';

=======
>>>>>>> Stashed changes
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

  /// Haversine formula — returns distance in metres
  double distanceTo(Location other) {
    const double R = 6371000;
    final double lat1 = _rad(latitude);
    final double lat2 = _rad(other.latitude);
    final double deltaLat = _rad(other.latitude - latitude);
    final double deltaLon = _rad(other.longitude - longitude);

    final double a =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  static double _rad(double degree) => degree * pi / 180;

  @override
  String toString() => 'Location($id, $latitude, $longitude)';
}
