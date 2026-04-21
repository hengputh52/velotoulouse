import 'package:flutter/material.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// Reusable widget to display pass details in a card format
class PassDetailsCard extends StatelessWidget {
  final Pass pass;

  const PassDetailsCard({super.key, required this.pass});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacings.m),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(AppSpacings.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pass.type.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.green.shade700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.m),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expires',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutralLight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    pass.expiresAt.toString().split(' ')[0],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Days Left',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutralLight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${pass.daysLeft} days',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
