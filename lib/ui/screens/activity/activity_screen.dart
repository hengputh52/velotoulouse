import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/activity/activity_content.dart';
import 'package:velotoulouse/ui/screens/activity/activity_view_model.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModel, String?>(
      selector: (_, vm) => vm.currentUser?.id,
      builder: (context, userId, _) {
        // Load activity data when user ID changes
        if (userId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ActivityViewModel>().loadActivity(userId);
          });
        }

        return const ActivityContent();
      },
    );
  }
}
