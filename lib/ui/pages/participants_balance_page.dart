import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class ParticipantsBalancePage extends StatelessWidget {
  const ParticipantsBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(AppStrings.participantsBalanceTitle)),
    );
  }
}

