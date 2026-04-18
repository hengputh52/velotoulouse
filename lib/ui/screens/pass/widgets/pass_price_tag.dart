import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class PassPriceTag extends StatelessWidget {
  final double amount;
  final String label;

  const PassPriceTag({
    super.key,
    required this.amount,
    this.label = 'Total',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacings.s),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            Text(
              amount.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
