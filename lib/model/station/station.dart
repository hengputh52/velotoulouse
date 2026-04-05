enum SlotStatus { availableBike, empty }

class Station {
  final String id;
  final String name;
  final List<BikeSlot> bikeSlots;

  const Station({
    required this.id,
    required this.name,
    required this.bikeSlots,
  });
}

class BikeSlot {
  final String id;
  final int slotNumber;
  final SlotStatus status;

  const BikeSlot({
    required this.id,
    required this.slotNumber,
    required this.status,
  });

  bool get canBook => status == SlotStatus.availableBike;
}
