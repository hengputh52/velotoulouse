import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/activity/activity_content.dart';
import 'package:velotoulouse/ui/screens/activity/activity_view_model.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reload activity when screen comes to foreground
    if (state == AppLifecycleState.resumed) {
      final userId = context.read<AuthViewModel>().currentUser?.id;
      if (userId != null && userId.isNotEmpty) {
        context.read<ActivityViewModel>().loadActivity(userId);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
