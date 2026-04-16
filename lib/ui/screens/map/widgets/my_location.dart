import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// LocationFabWidget — StatelessWidget
/// The circular button bottom-right that centers map on user location
class LocationFabWidget extends StatelessWidget {
  final bool isLocating;
  final VoidCallback onTap;

  const LocationFabWidget({
    super.key,
    required this.isLocating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLocating
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.my_location, color: AppColors.primary, size: 22),
      ),
    );
  }
}
