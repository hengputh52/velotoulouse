import 'package:flutter/material.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacings.radius),
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
        ),
        padding: EdgeInsets.all(AppSpacings.m),
        child: Row(
          children: [
            Icon(
              _getIconForMethod(method),
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 28,
            ),
            SizedBox(width: AppSpacings.m),
            Expanded(
              child: Text(
                _getLabelForMethod(method),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.black,
                ),
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: isSelected ? method : null,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForMethod(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.card => Icons.credit_card,
      PaymentMethod.mobileMoney => Icons.phone_android,
      PaymentMethod.cash => Icons.money,
    };
  }

  String _getLabelForMethod(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.card => 'Credit/Debit Card',
      PaymentMethod.mobileMoney => 'Mobile Money',
      PaymentMethod.cash => 'Cash',
    };
  }
}
