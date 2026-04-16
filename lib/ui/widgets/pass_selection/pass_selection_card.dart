import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// Data class for a single perk line on a pass card
class PassPerk {
  final IconData icon;
  final String text;
  const PassPerk({required this.icon, required this.text});
}

/// PassSelectionCard — driven by parameters, no hardcoded content
class PassSelectionCard extends StatelessWidget {
  final String name;
  final String price;
  final List<PassPerk> perks;

  const PassSelectionCard({
    super.key,
    required this.name,
    required this.price,
    required this.perks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacings.radius),
        color: AppColors.backgroundPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name + Price row ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacings.m),

          // ── Perks list ────────────────────────────────────
          ...perks.map(
            (perk) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(perk.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      perk.text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacings.m),

          // ── Select Pass button ────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.radius),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Select Pass',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
