import 'package:flutter/material.dart';

import '../../constants/app_images.dart';
import '../widgets/dialogs/no_internet_dialog.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.noInternetBackground,
            fit: BoxFit.cover,
          ),
          const NoInternetDialog(),
        ],
      ),
    );
  }
}
