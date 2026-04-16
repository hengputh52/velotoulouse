import 'package:velotoulouse/model/location/location.dart';

enum SlotStatus { available, empty }

class Station {
  final String id;
  final String locationId;
  final String name;
  final List<BikeSlot> slots;
  final Location location;

  const Station({
    required this.id,
    required this.locationId,
    required this.name,
    required this.slots,
    required this.location,
  });
  bool get hasBikesAvailable => slots.any((s) => s.isAvailable);

  int get availableBikes => slots.where((s) => s.isAvailable).length;

  int get totalDocks => slots.length;
  double get latitude => location.latitude;
  double get longitude => location.longitude;
  String? get address => location.address;

  int get availableCount => availableBikes;
}

class BikeSlot {
  final String id;
  final String stationId;
  final int slotNumber;
  final bool isAvailable;

  const BikeSlot({
    required this.id,
    required this.stationId,
    required this.slotNumber,
    required this.isAvailable,
  });

  bool get canBook => isAvailable;
}
