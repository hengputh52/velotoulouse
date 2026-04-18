import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/auth/auth_screen_content.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModel, AuthViewModel>(
      selector: (_, vm) => vm,
      builder: (context, vm, _) {
        return const AuthScreenContent();
      },
    );
  }
}
