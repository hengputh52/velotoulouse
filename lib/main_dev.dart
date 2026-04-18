import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository_mock.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository_mockl.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository_mock.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/data/repositories/station/station_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/station/station_repository_mock.dart';
import 'package:velotoulouse/data/repositories/user/mock_auth_repository.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/data/repositories/user/user_repository_firebase.dart';
import 'package:velotoulouse/main_common.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_view_model.dart';

List<InheritedProvider> get devProviders {
  return [
    Provider<StationRepository>(create: (_) => FirebaseStationRepository()),
    Provider<PassRepository>(create: (_) => FirebasePassRepository()),
    Provider<BookingRepository>(create: (_) => FirebaseBookingRepository()),
    Provider<PaymentRepository>(create: (_) => FirebasePaymentRepository()),
    Provider<AuthRepository>(create: (_) => FirebaseAuthRepository()),

    ChangeNotifierProvider<AuthViewModel>(create: (context) => AuthViewModel(context.read<AuthRepository>())),
    ChangeNotifierProvider<PassSelectionViewModel>(create: (context) => PassSelectionViewModel
    (context.read<PassRepository>(),
    context.read<PaymentRepository>()),)
  ];
}

void main() {
  mainCommon(devProviders);
}
