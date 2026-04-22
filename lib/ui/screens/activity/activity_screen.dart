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

class _ActivityScreenState extends State<ActivityScreen> {
  String? _loadedUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userId = context.watch<AuthViewModel>().currentUser?.id;
    if (userId != null && userId.isNotEmpty && userId != _loadedUserId) {
      _loadedUserId = userId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ActivityViewModel>().loadActivity(userId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ActivityContent();
  }
}
