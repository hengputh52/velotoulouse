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

  int get availableBikes => slots.where((s) => s.isAvailable).length;

  double get latitude => location.latitude;
  double get longitude => location.longitude;
  String? get address => location.address;


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

  
}
