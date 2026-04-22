import 'package:get_it/get_it.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository_mock.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository_mock.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository_mock.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/data/repositories/station/station_repository_mock.dart';
import 'package:velotoulouse/data/repositories/user/mock_auth_repository.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/map/view_model/active_booking_view_model.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_view_model.dart';
import 'package:velotoulouse/ui/screens/payment/payment_view_model.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_view_model.dart';
import 'package:velotoulouse/ui/states/auth_state.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register Repositories (using mock implementations for testing)
  getIt.registerSingleton<AuthRepository>(MockAuthRepository());

  getIt.registerSingleton<StationRepository>(MockStationRepository());

  getIt.registerSingleton<PassRepository>(MockPassRepository());

  getIt.registerSingleton<PaymentRepository>(MockPaymentRepository());

  getIt.registerSingleton<BookingRepository>(MockBookingRepository());

  // Register Global ViewModels (Singletons)
  getIt.registerSingleton<AuthState>(AuthState());

  getIt.registerSingleton<AuthViewModel>(
    AuthViewModel(getIt<AuthRepository>(), getIt<AuthState>()),
  );

  getIt.registerSingleton<PassSelectionViewModel>(
    PassSelectionViewModel(getIt<PassRepository>(), getIt<PaymentRepository>()),
  );

  getIt.registerSingleton<ActiveBookingViewModel>(ActiveBookingViewModel());

  // Register Screen ViewModels (Factories - new instance each time)
  getIt.registerFactory<StationDetailViewModel>(
    () => StationDetailViewModel(getIt<StationRepository>()),
  );

  getIt.registerFactory<PaymentViewModel>(
    () => PaymentViewModel(
      getIt<PaymentRepository>(),
      getIt<PassRepository>(),
      getIt<BookingRepository>(),
    ),
  );
}
