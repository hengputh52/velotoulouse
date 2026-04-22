import 'package:velotoulouse/data/dtos/bike_slot_dto.dart';
import 'package:velotoulouse/data/dtos/location_dto.dart';
import 'package:velotoulouse/model/station/station.dart';

class StationDto {
  static const String idKey = 'id';
  static const String locationIdKey = 'locationId';
  static const String nameKey = 'name';
  static const String slotsKey = 'slots';
  static const String locationKey = 'location';

  static Station fromJson(String id, Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[locationIdKey] is String);
    assert(json[nameKey] is String);
    assert(json[locationKey] is Map<String, dynamic>);

    final locationData = json[locationKey] as Map<String, dynamic>;
    final locationId = json[locationIdKey] as String;
    final location = LocationDto.fromJson(locationId, locationData);


    List<BikeSlot> slotsList = [];
    
    if (json[slotsKey] != null) {
      final slotsData = json[slotsKey];
      
      if (slotsData is List) {
        // Handle as List
        slotsList = (slotsData)
            .map((slot) {
              final slotData = slot as Map<String, dynamic>;
              final slotId = slotData[BikeSlotDto.idKey] as String;
              return BikeSlotDto.fromJson(slotId, slotData);
            })
            .toList();
      } else if (slotsData is Map) {

        slotsList = slotsData.entries
            .map((entry) {
              final slotData = entry.value as Map<String, dynamic>;
              final slotId = entry.key;
              return BikeSlotDto.fromJson(slotId, slotData);
            })
            .toList();
      }
    }

    return Station(
      id: json[idKey],
      locationId: json[locationIdKey],
      name: json[nameKey],
      location: location,
      slots: slotsList,
    );
  }

  /// Convert Station to JSON
  static Map<String, dynamic> toJson(Station station) {
    return {
      idKey: station.id,
      locationIdKey: station.locationId,
      nameKey: station.name,
      locationKey: LocationDto.toJson(station.location),
      slotsKey: station.slots.map((slot) => BikeSlotDto.toJson(slot)).toList(),
    };
  }
}
