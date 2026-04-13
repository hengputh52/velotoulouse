import 'package:velotoulouse/model/station/station.dart';

class BikeSlotDto {
  final String id;
  final String stationId;
  final int slotNumber;
  final bool isAvailable;

  const BikeSlotDto({
    required this.id,
    required this.stationId,
    required this.slotNumber,
    required this.isAvailable,
  });

  factory BikeSlotDto.fromJson(Map<String, dynamic> json) {
    return BikeSlotDto(
      id: json['id'] as String,
      stationId: json['stationId'] as String,
      slotNumber: json['slotNumber'] as int,
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'slotNumber': slotNumber,
      'isAvailable': isAvailable,
    };
  }

  BikeSlot toModel() {
    return BikeSlot(
      id: id,
      stationId: stationId,
      slotNumber: slotNumber,
      isAvailable: isAvailable,
    );
  }

  factory BikeSlotDto.fromModel(BikeSlot model) {
    return BikeSlotDto(
      id: model.id,
      stationId: model.stationId,
      slotNumber: model.slotNumber,
      isAvailable: model.isAvailable,
    );
  }
}
