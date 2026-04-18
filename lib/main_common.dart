// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:velotoulouse/ui/screens/pass_selection/pass_selection_screen.dart';
// import 'package:velotoulouse/ui/theme/theme.dart';
// import 'package:velotoulouse/ui/widgets/bottom_bar/bottom_bar.dart';

// void mainCommon(List<InheritedProvider> providers) {
//   runApp(
//     MultiProvider(
//       providers: providers,
//       child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: appTheme,
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Test")),
//       bottomNavigationBar: BottomBar(),
//       body: PassSelectionScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< Updated upstream
=======
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
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/map/widgets/active_booking_panel.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_view_model.dart';
import 'package:velotoulouse/ui/screens/pass_selection/pass_selection_screen.dart';
import 'package:velotoulouse/ui/screens/payment/payment_view_model.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_view_model.dart';
>>>>>>> Stashed changes
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/bottom_bar/bottom_bar.dart';

void mainCommon(List<InheritedProvider> providers) {
<<<<<<< Updated upstream
  runApp(MultiProvider(providers: providers, child: const VeloToulouseApp()));
=======
  runApp(
    MultiProvider(
      providers: [
        ...providers,
        
        // ============================================
        // 1 - INJECT REPOSITORIES
        // ============================================
        Provider<AuthRepository>(
          create: (_) => MockAuthRepository(),
        ),
        Provider<StationRepository>(
          create: (_) => MockStationRepository(),
        ),
        Provider<PassRepository>(
          create: (_) => MockPassRepository(),
        ),
        Provider<PaymentRepository>(
          create: (_) => MockPaymentRepository(),
        ),
        Provider<BookingRepository>(
          create: (_) => MockBookingRepository(),
        ),

        // ============================================
        // 2 - INJECT GLOBAL STATE VIEWMODELS
        // ============================================
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider<PassSelectionViewModel>(
          create: (context) => PassSelectionViewModel(
            context.read<PassRepository>(),
            context.read<PaymentRepository>(),
          ),
        ),
        ChangeNotifierProvider<ActiveBookingViewModel>(
          create: (_) => ActiveBookingViewModel(),
        ),

        // ============================================
        // 3 - INJECT SCREEN-LEVEL VIEWMODELS
        // ============================================
        ProxyProvider<StationRepository, StationDetailViewModel>(
          update: (_, stationRepo, __) => StationDetailViewModel(stationRepo),
        ),
        ProxyProvider2<PaymentRepository, PassRepository, PaymentViewModel>(
          update: (_, paymentRepo, passRepo, __) => PaymentViewModel(
            paymentRepo,
            passRepo,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
>>>>>>> Stashed changes
}

class VeloToulouseApp extends StatelessWidget {
  const VeloToulouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< Updated upstream
      title: 'VeloToulouse',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const BottomBar(), // ← single entry point
=======
      title: 'Velotoulouse',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: const PassSelectionScreen(),
>>>>>>> Stashed changes
    );
  }
}
