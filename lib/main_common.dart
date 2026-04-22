import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/ui/screens/auth/auth_screen.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/states/auth_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/bottom_bar/bottom_bar.dart';

void mainCommon(List<InheritedProvider> providers) {
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velotoulouse',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    Widget screen = vm.currentUser == null
        ? const AuthScreen()
        : const BottomBar();
    return screen;
    //     // Show auth screen if not authenticated
    //     if (authVM.currentUser == null) {
    //       return const AuthScreen();
    //     }
    //     // Show map with bottom bar if authenticated
    //     return const BottomBar();
    //   },
    // );
  }
}
