import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// ErrorBanner — StatelessWidget
/// Shows when stations fail to load, with retry button
class ErrorBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorBanner({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(AppSpacings.radius),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Could not load stations',
              style: TextStyle(fontSize: 13, color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}