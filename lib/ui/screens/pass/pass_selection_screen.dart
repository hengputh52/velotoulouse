import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_content.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_view_model.dart';

class PassSelectionScreen extends StatelessWidget {
  const PassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PassSelectionViewModel, PassSelectionViewModel>(
      selector: (_, vm) => vm,
      builder: (context, vm, _) {
        return const PassSelectionContent();
      },
    );
  }
}
