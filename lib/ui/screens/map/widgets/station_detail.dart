import 'package:flutter/material.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// StationDetailScreen — full screen pushed via Navigator.push
/// Matches the Figma "Station Detail" design (image 3)
class StationDetailScreen extends StatelessWidget {
  final Station station;
  final String distanceText;

  const StationDetailScreen({
    super.key,
    required this.station,
    required this.distanceText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Station Detail',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Station name + distance ─────────────────────
            Text(
              station.name.toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            if (distanceText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '$distanceText — from your current location',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ),

            const SizedBox(height: AppSpacings.l),

            // ── Stats row ────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatBox(
                  icon: Icons.pedal_bike,
                  count: station.availableCount,
                  label: 'Available bike',
                ),
                Container(width: 1, height: 60, color: Colors.grey.shade200),
                _StatBox(
                  icon: Icons.local_parking,
                  count: station.totalDocks,
                  label: 'Available dock',
                ),
              ],
            ),

            const SizedBox(height: AppSpacings.m),
            const Divider(),
            const SizedBox(height: AppSpacings.s),

            // ── Slot list header ─────────────────────────────
            Text(
              'Slot No.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacings.s),

            // ── Slot rows ────────────────────────────────────
            ...station.slots.map((slot) => _SlotRow(slot: slot)),

            const SizedBox(height: AppSpacings.xl),

            // ── Choose Your Pass ─────────────────────────────
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'Choose '),
                  TextSpan(
                    text: 'Your Pass',
                    style: TextStyle(color: Color(0xFF1275E2)),
                  ),
                  TextSpan(text: ' ?'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacings.m),

            _PassOptionRow(
              icon: Icons.confirmation_number_outlined,
              label: 'Single Ticket For a Single Ride',
            ),
            _PassOptionRow(icon: Icons.star_border, label: 'Subscription Plan'),

            const SizedBox(height: AppSpacings.l),

            // ── Continue button ──────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: navigate to payment/pass selection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacings.radius),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacings.l),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatBox({
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.black87),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class _SlotRow extends StatelessWidget {
  final BikeSlot slot;

  const _SlotRow({required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Slot number
          SizedBox(
            width: 20,
            child: Text(
              '${slot.slotNumber}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),

          // Bike icon
          const Icon(Icons.pedal_bike, size: 22, color: Colors.black54),
          const SizedBox(width: 10),

          // Status
          Expanded(
            child: slot.isAvailable
                ? Row(
                    children: [
                      // Battery bar (always full since we have no battery % data)
                      Container(
                        width: 50,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Fully charged',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ],
                  )
                : Text(
                    'In maintenance',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
          ),

          // Action button
          if (slot.isAvailable)
            ElevatedButton(
              onPressed: () {
                // TODO: wire up booking flow
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Release the bike',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            )
          else
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.green),
            ),
        ],
      ),
    );
  }
}

class _PassOptionRow extends StatefulWidget {
  final IconData icon;
  final String label;

  const _PassOptionRow({required this.icon, required this.label});

  @override
  State<_PassOptionRow> createState() => _PassOptionRowState();
}

class _PassOptionRowState extends State<_PassOptionRow> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(widget.icon, size: 20, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(widget.label, style: const TextStyle(fontSize: 14)),
            ),
            Radio<bool>(
              value: true,
              groupValue: _selected ? true : null,
              onChanged: (_) => setState(() => _selected = !_selected),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
