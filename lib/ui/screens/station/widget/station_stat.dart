import 'package:flutter/material.dart';

/// StatBox — displays a single stat (bikes or docks) in the station detail header
class StationStatBox extends StatelessWidget {
  final IconData? icon;
  final int count;
  final String label;

  /// When true, renders a black "P" parking badge instead of an icon
  final bool useParking;

  const StationStatBox({
    super.key,
    this.icon,
    required this.count,
    required this.label,
    this.useParking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (useParking)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          )
        else
          Icon(icon, size: 32, color: Colors.black87),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
