import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: AppRoutes.tabPages,
      ),
      bottomNavigationBar: SizedBox(
        height: AppSizes.bottomNavHeight,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: _NavIcon(AppIcons.navHome),
              label: AppStrings.navHome,
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(AppIcons.navCredit),
              label: AppStrings.navCredit,
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(AppIcons.navSettings),
              label: AppStrings.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: AppSizes.navIconSize,
      height: AppSizes.navIconSize,
    );
  }
}
