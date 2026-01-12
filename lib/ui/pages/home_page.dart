import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(AppStrings.navHome));
  }
}

