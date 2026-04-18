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
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/pass_selection_view_model/pass_selection_view_model.dart';
import 'package:velotoulouse/ui/states/auth_state.dart';
import 'package:velotoulouse/ui/states/pass_state.dart';

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
    // 2 - INJECT GLOBAL STATE HOLDERS
    // ============================================
    ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
    ChangeNotifierProvider<PassState>(create: (_) => PassState()),

    // ============================================
    // 3 - INJECT GLOBAL VIEWMODELS (depend on state)
    // ============================================
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
        context.read<PassState>(),
      ),
    ),



  ];
}

void main() {
  mainCommon(devProviders);
}
