import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class PassSelectionCard extends StatelessWidget {
  const PassSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacings.xxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacings.radius),
        color: AppColors.backgroundPrimary,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Day Pass', style: AppTextStyles.body),
              Text('\$5', style: AppTextStyles.body),
            ],
          ),

          SizedBox(height: 20),

          Column(
            children: [
              ListTile(
                leading: Icon(CupertinoIcons.time, color: AppColors.labelColor,),
                title: Text(
                  'Free Extra 30-min rides',
                  style: AppTextStyles.label,
                ),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.gift, color: AppColors.labelColor),
                title: Text(
                  'Discount 5% off next ride',
                  style: AppTextStyles.label,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacings.m),

          SizedBox(
            child: ElevatedButton(
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.radius),
                ),
                side: BorderSide(color: AppColors.backgroundColorMain),
              ),

              child: Text('Select Pass', style: AppTextStyles.label),
            ),
          ),
        ],
      ),
    );
  }
}
