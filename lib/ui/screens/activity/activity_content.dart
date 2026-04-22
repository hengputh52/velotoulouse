import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/screens/activity/activity_view_model.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';

class ActivityContent extends StatelessWidget {
  const ActivityContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivityViewModel>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Activity',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.neutralLight,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Bookings'),
              Tab(text: 'Passes'),
              Tab(text: 'Payments'),
            ],
          ),
        ),
        body: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ActivityViewModel vm) {
    // Show loading state
    if (vm.state == ViewState.loading &&
        vm.bookingHistory.isEmpty &&
        vm.passHistory.isEmpty &&
        vm.paymentHistory.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (vm.state == ViewState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppErrorBanner(
              message: vm.errorMessage ?? 'Failed to load activity',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final authVM = context.read<AuthViewModel>();
                final userId = authVM.currentUser?.id ?? '';
                if (userId.isNotEmpty) {
                  vm.retry(userId);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      children: [
        _buildBookingsTab(vm),
        _buildPassesTab(vm),
        _buildPaymentsTab(vm),
      ],
    );
  }

  Widget _buildBookingsTab(ActivityViewModel vm) {
    if (vm.bookingHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.pedal_bike_outlined,
        title: 'No Bookings Yet',
        description: 'Your bike bookings will appear here',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacings.l),
      itemCount: vm.bookingHistory.length,
      itemBuilder: (context, index) {
        final booking = vm.bookingHistory[index];
        final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

        return Card(
          margin: EdgeInsets.only(bottom: AppSpacings.m),
          child: Padding(
            padding: EdgeInsets.all(AppSpacings.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking #${booking.id.substring(0, 8)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        booking.status.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                Text(
                  'Station: ${booking.stationId}',
                  style: TextStyle(fontSize: 12, color: AppColors.secondary),
                ),
                Text(
                  'Slot: ${booking.bikeSlotId}',
                  style: TextStyle(fontSize: 12, color: AppColors.secondary),
                ),
                SizedBox(height: AppSpacings.s),
                Text(
                  dateFormat.format(booking.bookedAt),
                  style: TextStyle(fontSize: 11, color: AppColors.neutralLight),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPassesTab(ActivityViewModel vm) {
    if (vm.passHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.confirmation_number_outlined,
        title: 'No Passes Yet',
        description: 'Purchase a pass to get started',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacings.l),
      itemCount: vm.passHistory.length,
      itemBuilder: (context, index) {
        final pass = vm.passHistory[index];
        final dateFormat = DateFormat('MMM dd, yyyy');

        return Card(
          margin: EdgeInsets.only(bottom: AppSpacings.m),
          child: Padding(
            padding: EdgeInsets.all(AppSpacings.m),
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
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: pass.isActive ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pass.isActive ? 'ACTIVE' : 'EXPIRED',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purchased',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.neutralLight,
                          ),
                        ),
                        Text(
                          dateFormat.format(pass.purchasedAt),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Expires',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.neutralLight,
                          ),
                        ),
                        Text(
                          dateFormat.format(pass.expiresAt),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (pass.isActive)
                  Column(
                    children: [
                      SizedBox(height: AppSpacings.s),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSpacings.s),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${pass.daysLeft} days remaining',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentsTab(ActivityViewModel vm) {
    if (vm.paymentHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.payment_outlined,
        title: 'No Payments Yet',
        description: 'Your payment history will appear here',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacings.l),
      itemCount: vm.paymentHistory.length,
      itemBuilder: (context, index) {
        final payment = vm.paymentHistory[index];
        final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

        return Card(
          margin: EdgeInsets.only(bottom: AppSpacings.m),
          child: Padding(
            padding: EdgeInsets.all(AppSpacings.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getPurposeLabel(payment.purpose),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPaymentStatusColor(payment.status),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        payment.status.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      payment.method.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      '€${payment.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                Text(
                  dateFormat.format(payment.createdAt),
                  style: TextStyle(fontSize: 11, color: AppColors.neutralLight),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.neutralLight.withOpacity(0.5)),
          SizedBox(height: AppSpacings.l),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacings.s),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  String _getPurposeLabel(PaymentPurpose purpose) {
    return switch (purpose) {
      PaymentPurpose.singleTicket => 'Single Ticket',
      PaymentPurpose.dayPass => 'Day Pass',
      PaymentPurpose.monthlyPass => 'Monthly Pass',
      PaymentPurpose.annualPass => 'Annual Pass',
    };
  }

  Color _getStatusColor(BookingStatus status) {
    return switch (status) {
      BookingStatus.confirmed => Colors.green,
      BookingStatus.cancelled => Colors.red,
      BookingStatus.completed => Colors.blue,
    };
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.success => Colors.green,
      PaymentStatus.pending => Colors.orange,
      PaymentStatus.failed => Colors.red,
    };
  }
}
