import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/screens/activity/activity_screen.dart';
import 'package:velotoulouse/ui/screens/map/widgets/map_screen.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_screen.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  // Each screen connected to a tab
  final List<Widget> _screens = const [
    MapScreen(), // Tab 0 — Map
    PassSelectionScreen(), // Tab 1 — Passes
    ActivityScreen(), // Tab 2 — Activity
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all screens alive when switching tabs
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.backgroundColorMain,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.ticket),
            label: 'Pass',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Activity',
          ),
        ],
      ),
    );
  }
}
