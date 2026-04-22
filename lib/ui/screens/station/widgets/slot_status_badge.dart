import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class SlotStatusBadge extends StatelessWidget {
  final bool isAvailable;

  const SlotStatusBadge({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        isAvailable ? 'Available' : 'Occupied',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isAvailable
          ? Colors.green.shade600
          : Colors.grey.shade400,
      labelPadding: EdgeInsets.symmetric(horizontal: AppSpacings.s),
    );
  }
}
