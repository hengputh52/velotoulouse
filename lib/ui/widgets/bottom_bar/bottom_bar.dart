// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:velotoulouse/ui/theme/theme.dart';

// class BottomBar extends StatefulWidget {
//   const BottomBar({super.key});

//   @override
//   State<BottomBar> createState() => _BottomBarState();
// }

// class _BottomBarState extends State<BottomBar> {
//   int selectedIndex = 0;

//   void onTap(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: selectedIndex,
//       backgroundColor: AppColors.backgroundColorMain,
//       selectedItemColor: AppColors.textPrimary,
//       onTap: onTap,
//       items: [
//         BottomNavigationBarItem(icon: Icon(CupertinoIcons.map), label: 'Map'),
//         BottomNavigationBarItem(
//           icon: Icon(CupertinoIcons.ticket),
//           label: 'Pass',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.local_activity),
//           label: 'Activity',
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/screens/map/widgets/map_screen.dart';
import 'package:velotoulouse/ui/screens/pass_selection/pass_selection_screen.dart';
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
    _ActivityPlaceholder(), // Tab 2 — Activity (Member 3)
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

// Placeholder for Member 3's activity screen
class _ActivityPlaceholder extends StatelessWidget {
  const _ActivityPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Activity Screen\n(Coming soon)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
