import 'package:velotoulouse/data/dtos/bike_slot_dto.dart';
import 'package:velotoulouse/data/dtos/location_dto.dart';
import 'package:velotoulouse/model/station/station.dart';

class StationDto {
  final String id;
  final String locationId;
  final String name;
  final List<BikeSlotDto> slots;
  final LocationDto location;

  const StationDto({
    required this.id,
    required this.locationId,
    required this.name,
    required this.slots,
    required this.location,
  });

  factory StationDto.fromJson(Map<String, dynamic> json) {
    return StationDto(
      id: json['id'] as String,
      locationId: json['locationId'] as String,
      name: json['name'] as String,
      location: LocationDto.fromJson(json['location'] as Map<String, dynamic>),
      slots: (json['slots'] as List<dynamic>?)
              ?.map((slot) => BikeSlotDto.fromJson(slot as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
      'name': name,
      'location': location.toJson(),
      'slots': slots.map((slot) => slot.toJson()).toList(),
    };
  }

  Station toModel() {
    return Station(
      id: id,
      locationId: locationId,
      name: name,
      location: location.toModel(),
      slots: slots.map((slot) => slot.toModel()).toList(),
    );
  }

  factory StationDto.fromModel(Station model) {
    return StationDto(
      id: model.id,
      locationId: model.locationId,
      name: model.name,
      location: LocationDto.fromModel(model.location),
      slots: model.slots.map((slot) => BikeSlotDto.fromModel(slot)).toList(),
    );
  }
}
