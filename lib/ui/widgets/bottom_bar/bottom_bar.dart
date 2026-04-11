import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: AppColors.backgroundColorMain,
      selectedItemColor: AppColors.textPrimary,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.map), label: 'Map'),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.ticket),
          label: 'Pass',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: 'Activity',
        ),
      ],
    );
  }
}
