import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository_mock.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository_mockl.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository_mock.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/data/repositories/station/station_repository_mock.dart';
import 'package:velotoulouse/data/repositories/user/mock_auth_repository.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/main_common.dart';

List<InheritedProvider> get devProviders {
  return [
    Provider<StationRepository>(create: (_) => MockStationRepository()),
    Provider<PassRepository>(create: (_) => MockPassRepository()),
    Provider<BookingRepository>(create: (_) => MockBookingRepository()),
    Provider<PaymentRepository>(create: (_) => MockPaymentRepository()),
    Provider<AuthRepository>(create: (_) => MockAuthRepository()),
  ];
}

void main() {
  mainCommon(devProviders);
}
