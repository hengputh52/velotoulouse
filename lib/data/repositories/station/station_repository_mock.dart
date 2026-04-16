// import 'package:velotoulouse/data/repositories/station/station_repository.dart';
// import 'package:velotoulouse/model/location/location.dart';
// import 'package:velotoulouse/model/station/station.dart';

// class MockStationRepository implements StationRepository {
//   static final List<Station> _stations = [
//     Station(
//       id: 'station_1',
//       locationId: 'loc_1',
//       name: 'Central Station',
//       location: Location(
//         id: 'loc_1',
//         latitude: 11.5564,
//         longitude: 104.9282,
//         address: '123 Main Street',
//         city: 'Phnom Penh',
//       ),
//       slots: [
//         BikeSlot(
//           id: 'slot_1',
//           stationId: 'station_1',
//           slotNumber: 1,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_2',
//           stationId: 'station_1',
//           slotNumber: 2,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_3',
//           stationId: 'station_1',
//           slotNumber: 3,
//           isAvailable: false,
//         ),
//         BikeSlot(
//           id: 'slot_4',
//           stationId: 'station_1',
//           slotNumber: 4,
//           isAvailable: true,
//         ),
//       ],
//     ),
//     Station(
//       id: 'station_2',
//       locationId: 'loc_2',
//       name: 'Market Station',
//       location: Location(
//         id: 'loc_2',
//         latitude: 11.5534,
//         longitude: 104.9299,
//         address: '456 Market Road',
//         city: 'Phnom Penh',
//       ),
//       slots: [
//         BikeSlot(
//           id: 'slot_5',
//           stationId: 'station_2',
//           slotNumber: 1,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_6',
//           stationId: 'station_2',
//           slotNumber: 2,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_7',
//           stationId: 'station_2',
//           slotNumber: 3,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_8',
//           stationId: 'station_2',
//           slotNumber: 4,
//           isAvailable: false,
//         ),
//         BikeSlot(
//           id: 'slot_9',
//           stationId: 'station_2',
//           slotNumber: 5,
//           isAvailable: false,
//         ),
//       ],
//     ),
//     Station(
//       id: 'station_3',
//       locationId: 'loc_3',
//       name: 'Park Station',
//       location: Location(
//         id: 'loc_3',
//         latitude: 11.5623,
//         longitude: 104.9245,
//         address: '789 Park Avenue',
//         city: 'Phnom Penh',
//       ),
//       slots: [
//         BikeSlot(
//           id: 'slot_10',
//           stationId: 'station_3',
//           slotNumber: 1,
//           isAvailable: false,
//         ),
//         BikeSlot(
//           id: 'slot_11',
//           stationId: 'station_3',
//           slotNumber: 2,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_12',
//           stationId: 'station_3',
//           slotNumber: 3,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_13',
//           stationId: 'station_3',
//           slotNumber: 4,
//           isAvailable: true,
//         ),
//       ],
//     ),
//     Station(
//       id: 'station_4',
//       locationId: 'loc_4',
//       name: 'Airport Station',
//       location: Location(
//         id: 'loc_4',
//         latitude: 11.5657,
//         longitude: 104.8438,
//         address: 'Airport Road',
//         city: 'Phnom Penh',
//       ),
//       slots: [
//         BikeSlot(
//           id: 'slot_14',
//           stationId: 'station_4',
//           slotNumber: 1,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_15',
//           stationId: 'station_4',
//           slotNumber: 2,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_16',
//           stationId: 'station_4',
//           slotNumber: 3,
//           isAvailable: false,
//         ),
//         BikeSlot(
//           id: 'slot_17',
//           stationId: 'station_4',
//           slotNumber: 4,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_18',
//           stationId: 'station_4',
//           slotNumber: 5,
//           isAvailable: true,
//         ),
//         BikeSlot(
//           id: 'slot_19',
//           stationId: 'station_4',
//           slotNumber: 6,
//           isAvailable: false,
//         ),
//       ],
//     ),
//   ];

//   @override
//   Future<List<Station>> getStations() async {
//     await Future.delayed(const Duration(milliseconds: 600));
//     return _stations;
//   }

//   @override
//   Stream<List<Station>> watchStations() async* {
//     await Future.delayed(const Duration(milliseconds: 600));
//     yield _stations;
//   }

//   @override
//   Future<Station?> getStationById(String id) async {
//     await Future.delayed(const Duration(milliseconds: 600));
//     try {
//       return _stations.firstWhere((station) => station.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
// }
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/location/location.dart';
import 'package:velotoulouse/model/station/station.dart';

class MockStationRepository implements StationRepository {
  /// Stations match data.json exactly — Toulouse coordinates
  static final List<Station> _stations = [
    Station(
      id: 'station_1',
      locationId: 'loc_1',
      name: 'Station Capitole',
      location: Location(
        id: 'loc_1',
        latitude: 43.6047,
        longitude: 1.4442,
        address: 'Place du Capitole',
        city: 'Toulouse',
      ),
      slots: [
        BikeSlot(
          id: 'slot_1_1',
          stationId: 'station_1',
          slotNumber: 1,
          isAvailable: true,
        ),
        BikeSlot(
          id: 'slot_1_2',
          stationId: 'station_1',
          slotNumber: 2,
          isAvailable: true,
        ),
        BikeSlot(
          id: 'slot_1_3',
          stationId: 'station_1',
          slotNumber: 3,
          isAvailable: false,
        ),
        BikeSlot(
          id: 'slot_1_4',
          stationId: 'station_1',
          slotNumber: 4,
          isAvailable: true,
        ),
        BikeSlot(
          id: 'slot_1_5',
          stationId: 'station_1',
          slotNumber: 5,
          isAvailable: false,
        ),
      ],
    ),
    Station(
      id: 'station_2',
      locationId: 'loc_2',
      name: 'Station Rue de Metz',
      location: Location(
        id: 'loc_2',
        latitude: 43.6108,
        longitude: 1.4442,
        address: 'Rue de Metz',
        city: 'Toulouse',
      ),
      slots: [
        BikeSlot(
          id: 'slot_2_1',
          stationId: 'station_2',
          slotNumber: 1,
          isAvailable: true,
        ),
        BikeSlot(
          id: 'slot_2_2',
          stationId: 'station_2',
          slotNumber: 2,
          isAvailable: true,
        ),
        BikeSlot(
          id: 'slot_2_3',
          stationId: 'station_2',
          slotNumber: 3,
          isAvailable: true,
        ),
      ],
    ),
    Station(
      id: 'station_3',
      locationId: 'loc_3',
      name: 'Station Gare Matabiau',
      location: Location(
        id: 'loc_3',
        latitude: 43.5963,
        longitude: 1.4544,
        address: 'Gare Matabiau',
        city: 'Toulouse',
      ),
      slots: [
        BikeSlot(
          id: 'slot_3_1',
          stationId: 'station_3',
          slotNumber: 1,
          isAvailable: false,
        ),
        BikeSlot(
          id: 'slot_3_2',
          stationId: 'station_3',
          slotNumber: 2,
          isAvailable: true,
        ),
      ],
    ),
    Station(
      id: 'station_4',
      locationId: 'loc_4',
      name: 'Station UPS',
      location: Location(
        id: 'loc_4',
        latitude: 43.6315,
        longitude: 1.4668,
        address: 'Université Paul Sabatier',
        city: 'Toulouse',
      ),
      slots: [
        BikeSlot(
          id: 'slot_4_1',
          stationId: 'station_4',
          slotNumber: 1,
          isAvailable: true,
        ),
        BikeSlot(
          id: 'slot_4_2',
          stationId: 'station_4',
          slotNumber: 2,
          isAvailable: true,
        ),
      ],
    ),
    Station(
      id: 'station_5',
      locationId: 'loc_5',
      name: 'Station Reynerie',
      location: Location(
        id: 'loc_5',
        latitude: 43.5855,
        longitude: 1.4507,
        address: 'Parc de la Reynerie',
        city: 'Toulouse',
      ),
      slots: [
        BikeSlot(
          id: 'slot_5_1',
          stationId: 'station_5',
          slotNumber: 1,
          isAvailable: true,
        ),
      ],
    ),
  ];

  @override
  Future<List<Station>> getStations() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _stations;
  }

  @override
  Stream<List<Station>> watchStations() async* {
    await Future.delayed(const Duration(milliseconds: 600));
    yield _stations;
  }

  @override
  Future<Station?> getStationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      return _stations.firstWhere((station) => station.id == id);
    } catch (e) {
      return null;
    }
  }
}
