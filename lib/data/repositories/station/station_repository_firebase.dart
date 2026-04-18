// lib/data/repositories/station/station_repository_firebase.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velotoulouse/data/dtos/bike_slot_dto.dart';
import 'package:velotoulouse/data/dtos/station_dto.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/station/station.dart';

class FirebaseStationRepository implements StationRepository {
  final Uri stationsUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/stations.json',
  );

  final Uri slotsUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/slots.json',
  );

  @override
  Future<List<Station>> getStations() async {
    try {
      print('📍 Fetching stations...');
      final http.Response response = await http.get(stationsUri);
      print('📍 Station API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          print('⚠️ Firebase database is empty (no stations)');
          return [];
        }

        // Fetch slots to attach to stations
        final slotsResponse = await http.get(slotsUri);
        Map<String, dynamic> slotsData = {};
        if (slotsResponse.statusCode == 200 && slotsResponse.body != 'null') {
          slotsData = json.decode(slotsResponse.body) as Map<String, dynamic>;
          print('📍 Loaded ${slotsData.length} slots');
        }

        Map<String, dynamic> stationsJson = json.decode(response.body);
        List<Station> result = [];

        for (final entry in stationsJson.entries) {
          try {
            final stationData = entry.value as Map<String, dynamic>;
            final stationId = entry.key;

            // Get all slots for this station
            final stationSlots = slotsData.entries
                .where((slot) =>
                    (slot.value as Map<String, dynamic>)['stationId'] ==
                    stationId)
                .map((slot) => slot.value)
                .toList();

            // Add slots array to station data
            stationData['slots'] = stationSlots;

            result.add(StationDto.fromJson(stationId, stationData));
          } catch (dtoError) {
            print('❌ Error parsing station ${entry.key}: $dtoError');
          }
        }
        return result;
      } else {
        print('❌ Server error: ${response.statusCode}');
        throw Exception('Failed to load stations: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception loading stations: $e');
      rethrow;
    }
  }

  @override
  Stream<List<Station>> watchStations() async* {
    try {
      final stations = await getStations();
      yield stations;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Station?> getStationById(String id) async {
    try {
      final Uri stationUri = Uri.https(
        'velotoulouse-42876-default-rtdb.firebaseio.com',
        '/stations/$id.json',
      );

      final http.Response response = await http.get(stationUri);

      if (response.statusCode == 200) {
        Map<String, dynamic> stationData = json.decode(response.body);

        // Fetch slots for this station
        final slotsResponse = await http.get(slotsUri);
        if (slotsResponse.statusCode == 200 && slotsResponse.body != 'null') {
          Map<String, dynamic> slotsData =
              json.decode(slotsResponse.body) as Map<String, dynamic>;

          // Get slots for this specific station
          final stationSlots = slotsData.entries
              .where((slot) =>
                  (slot.value as Map<String, dynamic>)['stationId'] == id)
              .map((slot) => slot.value)
              .toList();

          stationData['slots'] = stationSlots;
        }

        return StationDto.fromJson(id, stationData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load station');
      }
    } catch (e) {
      rethrow;
    }
  }
}
