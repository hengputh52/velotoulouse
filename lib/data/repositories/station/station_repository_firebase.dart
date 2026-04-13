// lib/data/repositories/station/station_repository_firebase.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velotoulouse/data/dtos/station_dto.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/station/station.dart';

class FirebaseStationRepository implements StationRepository {
  final Uri stationsUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/stations.json',
  );

  @override
  Future<List<Station>> getStations() async {
    try {
      final http.Response response = await http.get(stationsUri);

      if (response.statusCode == 200) {
        Map<String, dynamic> stationsJson = json.decode(response.body);
        List<Station> result = [];

        for (final entry in stationsJson.entries) {
          result.add(StationDto.fromJson(entry.value).toModel());
        }
        return result;
      } else {
        throw Exception('Failed to load stations');
      }
    } catch (e) {
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
        Map<String, dynamic> stationJson = json.decode(response.body);
        return StationDto.fromJson(stationJson).toModel();
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
