import 'package:flutter/material.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class OrderSummaryCard extends StatelessWidget {
  final PaymentPurpose purpose;
  final double amount;

  const OrderSummaryCard({
    super.key,
    required this.purpose,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacings.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSpacings.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _purposeLabel(purpose),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.m),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: AppSpacings.m),
            if (_isDurationRelevant(purpose))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _durationText(purpose),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: AppSpacings.m),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _purposeLabel(PaymentPurpose purpose) {
    return switch (purpose) {
      PaymentPurpose.singleTicket => 'Single Ride Ticket',
      PaymentPurpose.dayPass => 'Day Pass',
      PaymentPurpose.monthlyPass => 'Monthly Pass',
      PaymentPurpose.annualPass => 'Annual Pass',
    };
  }

  bool _isDurationRelevant(PaymentPurpose purpose) {
    return purpose != PaymentPurpose.singleTicket;
  }

  String _durationText(PaymentPurpose purpose) {
    return switch (purpose) {
      PaymentPurpose.dayPass => 'Valid for 24 hours from activation',
      PaymentPurpose.monthlyPass => 'Valid for 30 days from activation',
      PaymentPurpose.annualPass => 'Valid for 365 days from activation',
      _ => '',
    };
  }
}
