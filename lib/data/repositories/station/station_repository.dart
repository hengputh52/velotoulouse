import 'package:velotoulouse/model/station/station.dart';

abstract class StationRepository {
  Future<List<Station>> getStations();

  Stream<List<Station>> watchStations();

  Future<Station?> getStationById(String id);
}
