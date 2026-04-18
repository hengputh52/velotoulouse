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
    return GestureDetector(
      onTap: isCurrentPlan ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacings.radius),
        ),
        padding: EdgeInsets.all(AppSpacings.l),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: AppSpacings.s),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.s,
                  vertical: 4,
                ),
                child: Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            if (isCurrentPlan)
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Text(
                    'Current plan',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
