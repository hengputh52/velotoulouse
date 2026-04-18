import '../../model/station/station.dart';

class BikeSlotDto {
  static const String idKey = 'id';
  static const String stationIdKey = 'stationId';
  static const String slotNumberKey = 'slotNumber';
  static const String isAvailableKey = 'isAvailable';

  static BikeSlot fromJson(String id, Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[stationIdKey] is String);
    assert(json[slotNumberKey] is int);
    assert(json[isAvailableKey] is bool);

    return BikeSlot(
      id: json[idKey],
      stationId: json[stationIdKey],
      slotNumber: json[slotNumberKey],
      isAvailable: json[isAvailableKey],
    );
  }

  /// Convert BikeSlot to JSON
  static Map<String, dynamic> toJson(BikeSlot slot) {
    return {
      idKey: slot.id,
      stationIdKey: slot.stationId,
      slotNumberKey: slot.slotNumber,
      isAvailableKey: slot.isAvailable,
    };
  }
}
