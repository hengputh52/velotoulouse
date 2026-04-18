import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class AppErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorBanner({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(AppSpacings.radius),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
