import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/data/repositories/station/station_repository_firebase.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/data/repositories/user/user_repository_firebase.dart';
import 'package:velotoulouse/main_common.dart';
import 'package:velotoulouse/ui/screens/activity/activity_view_model.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/booking/view_model/booking_view_model.dart';
import 'package:velotoulouse/ui/screens/map/view_model/station_view_model.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_view_model.dart';
import 'package:velotoulouse/ui/screens/payment/payment_view_model.dart';
import 'package:velotoulouse/ui/states/auth_state.dart';

List<InheritedProvider> get devProviders {
  return [
    // ============================================
    // 1 - INJECT REPOSITORIES (Firebase)
    // ============================================
    Provider<AuthRepository>(create: (_) => FirebaseAuthRepository()),
    Provider<StationRepository>(create: (_) => FirebaseStationRepository()),
    Provider<PassRepository>(create: (_) => FirebasePassRepository()),
    Provider<PaymentRepository>(create: (_) => FirebasePaymentRepository()),
    Provider<BookingRepository>(create: (_) => FirebaseBookingRepository()),

    // ============================================
    // 2 - INJECT GLOBAL STATE & VIEWMODELS
    // ============================================
    ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        context.read<AuthRepository>(),
        context.read<AuthState>(),
      ),
    ),
    ChangeNotifierProvider<PassSelectionViewModel>(
      create: (context) => PassSelectionViewModel(
        context.read<PassRepository>(),
        context.read<PaymentRepository>(),
      ),
    ),
    ChangeNotifierProvider<PaymentViewModel>(
      create: (context) => PaymentViewModel(
        context.read<PaymentRepository>(),
        context.read<PassRepository>(),
        context.read<BookingRepository>(),
      ),
    ),
    ChangeNotifierProvider<BookingViewModel>(
      create: (context) => BookingViewModel(
        context.read<BookingRepository>(),
        context.read<PassRepository>(),
        context.read<StationRepository>(),
      ),
    ),
    ChangeNotifierProvider<StationViewModel>(
      create: (context) => StationViewModel(
        stationRepository: context.read<StationRepository>(),
      ),
    ),
    ChangeNotifierProvider<ActivityViewModel>(
      create: (context) => ActivityViewModel(
        context.read<BookingRepository>(),
        context.read<PassRepository>(),
        context.read<PaymentRepository>(),
      ),
    ),
  ];
}

void main() {
  mainCommon(devProviders);
}
