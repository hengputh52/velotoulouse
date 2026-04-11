import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/pass_selection/pass_selection_card.dart';

class PassSelectionScreen extends StatelessWidget {
  const PassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),

        child: Column(
          children: [
            Text('Choose Your Plan', style: AppTextStyles.heading),

            SizedBox(height: AppSpacings.m),

            PassSelectionCard(),

            SizedBox(height: AppSpacings.m),

            PassSelectionCard(),
          ],
        ),
      ),
    );
  }
}
