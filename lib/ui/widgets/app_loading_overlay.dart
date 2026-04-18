import 'package:flutter/material.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isVisible;
  final String message;

  const AppLoadingOverlay({
    super.key,
    required this.isVisible,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Visibility(
        visible: isVisible,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
