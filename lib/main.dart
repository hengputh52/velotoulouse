import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/screens/pass_selection/pass_selection_screen.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/bottom_bar/bottom_bar.dart';
import 'package:velotoulouse/ui/widgets/pass_selection/pass_selection_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test")),
      bottomNavigationBar: BottomBar(),
      body: PassSelectionScreen()
    );
  }
}
