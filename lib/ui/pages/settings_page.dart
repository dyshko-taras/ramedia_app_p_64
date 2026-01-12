import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(AppStrings.settingsTitle));
  }
}

