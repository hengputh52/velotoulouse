import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/screens/booking/booking_screen.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_screen.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_view_model.dart';
import 'package:velotoulouse/ui/screens/station/station_slot_row.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';

class StationDetailContent extends StatelessWidget {
  const StationDetailContent({super.key});

  // Navigate to booking screen
  void _navigateToBooking(BuildContext context, StationDetailViewModel vm) {
    if (vm.station == null || vm.selectedSlotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bike slot')),
      );
      return;
    }

    // Import BookingScreen at top of file
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          stationId: vm.station!.id,
          bikeSlotId: vm.selectedSlotId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<StationDetailViewModel>(
          builder: (context, vm, _) {
            return Text(
              vm.station?.name ?? 'Station',
              style: const TextStyle(color: Colors.black),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<StationDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.state == ViewState.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: AppSpacings.m),
                  const Text('Loading station...'),
                ],
              ),
            );
          }

          if (vm.state == ViewState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppErrorBanner(
                    message: vm.errorMessage ?? 'Failed to load station',
                  ),
                  SizedBox(height: AppSpacings.m),
                  AppPrimaryButton(
                    label: 'Retry',
                    onPressed: () {
                      // Get stationId from navigation arguments or parent
                      // For now, we'll use context to get it
                      final route = ModalRoute.of(context);
                      if (route?.settings.arguments is String) {
                        vm.retry(route!.settings.arguments as String);
                      }
                    },
                  ),
                ],
              ),
            );
          }

          if (vm.station == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: AppSpacings.m),
                  const Text('No slots found at this station'),
                ],
              ),
            );
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(padding: EdgeInsets.all(AppSpacings.l)),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
                      child: Text(
                        'Available Bikes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final slot = vm.station!.slots[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacings.l,
                          index == 0 ? AppSpacings.m : AppSpacings.s,
                          AppSpacings.l,
                          AppSpacings.s,
                        ),
                        child: StationSlotRow(
                          slot: slot,
                          isSelected: vm.selectedSlotId == slot.id,
                          onSelected: (value) => vm.selectSlot(slot.id),
                        ),
                      );
                    }, childCount: vm.station!.slots.length),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
              // Bottom Sticky Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(AppSpacings.l),
                  child: AppPrimaryButton(
                    label: 'Book This Bike',
                    isLoading: vm.state == ViewState.loading,
                    onPressed: vm.selectedSlotId != null
                        ? () => _navigateToBooking(context, vm)
                        : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
