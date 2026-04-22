import 'package:flutter/material.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class PassTypeCard extends StatelessWidget {
  final PassType type;
  final double price;
  final String description;
  final String duration;
  final bool isSelected;
  final bool isCurrentPlan;
  final VoidCallback onTap;

  const PassTypeCard({
    super.key,
    required this.type,
    required this.price,
    required this.description,
    required this.duration,
    required this.isSelected,
    required this.isCurrentPlan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = isSelected;
    final Color currentAccent = const Color(0xFFE67E22);

    return GestureDetector(
      onTap: isCurrentPlan ? null : onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.all(AppSpacings.l),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: isPrimary
                  ? const LinearGradient(
                      colors: [Color(0xFF2F80ED), Color(0xFF1C5ED6)],
                    )
                  : null,
              color: isPrimary ? null : Colors.white,
              border: isCurrentPlan
                  ? Border.all(color: currentAccent, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                if (isCurrentPlan)
                  BoxShadow(
                    color: currentAccent.withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1,
                        color: isPrimary ? Colors.white70 : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPrimary ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),

                /// RIGHT (PRICE + CURRENT BADGE)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isCurrentPlan)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isPrimary ? Colors.white24 : currentAccent,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isPrimary ? Colors.white70 : currentAccent,
                          ),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isPrimary ? Colors.white : AppColors.primary,
                      ),
                    ),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: isPrimary ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// FEATURES (reuse description or expand later)
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: isPrimary ? Colors.white : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(
                      color: isPrimary ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacings.m),

            /// BUTTON / CURRENT PLAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCurrentPlan ? null : onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPrimary
                      ? Colors.white
                      : Colors.transparent,
                  foregroundColor: isPrimary ? Colors.blue : AppColors.primary,
                  side: isPrimary ? null : BorderSide(color: AppColors.primary),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  isCurrentPlan ? "Current Plan" : "Select Pass",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
              ],
            ),
          ),
          if (isCurrentPlan)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: currentAccent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'CURRENT PLAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
