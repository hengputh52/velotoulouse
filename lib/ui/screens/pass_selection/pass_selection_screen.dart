import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/pass_selection/pass_selection_card.dart';

class PassSelectionScreen extends StatelessWidget {
  const PassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacings.l),
          children: const [
            Text('Choose Your Plan', style: AppTextStyles.headingStatic),

            SizedBox(height: AppSpacings.m),

            PassSelectionCard(
              name: 'Day Pass',
              price: '\$5',
              perks: [
                PassPerk(
                  icon: Icons.timer_outlined,
                  text: 'Free Extra 30-min rides',
                ),
                PassPerk(
                  icon: Icons.card_giftcard_outlined,
                  text: 'Discount 5% off next ride',
                ),
              ],
            ),

            SizedBox(height: AppSpacings.m),

            PassSelectionCard(
              name: 'Monthly Pass',
              price: '\$30',
              perks: [
                PassPerk(
                  icon: Icons.all_inclusive,
                  text: 'Unlimited 45-min rides',
                ),
                PassPerk(
                  icon: Icons.card_giftcard_outlined,
                  text: 'Discount 10% off next ride',
                ),
                PassPerk(icon: Icons.support_agent, text: 'Priority support'),
              ],
            ),

            SizedBox(height: AppSpacings.m),

            PassSelectionCard(
              name: 'Annual Pass',
              price: '\$120',
              perks: [
                PassPerk(
                  icon: Icons.all_inclusive,
                  text: 'Unlimited 60-min rides',
                ),
                PassPerk(
                  icon: Icons.people_outline,
                  text: '2 guest passes per month',
                ),
                PassPerk(
                  icon: Icons.workspace_premium_outlined,
                  text: 'Premium support',
                ),
              ],
            ),

            SizedBox(height: AppSpacings.l),
          ],
        ),
      ),
    );
  }
}
