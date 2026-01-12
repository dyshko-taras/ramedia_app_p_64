import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import 'main_shell_cubit.dart';
import 'main_shell_state.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainShellCubit(initialIndex: initialIndex),
      child: const _MainShellView(),
    );
  }
}

class _MainShellView extends StatelessWidget {
  const _MainShellView();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocBuilder<MainShellCubit, MainShellState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.currentIndex,
              children: AppRoutes.tabPages,
            );
          },
        ),
        bottomNavigationBar: SizedBox(
          height: AppSizes.bottomNavHeight,
          child: BlocBuilder<MainShellCubit, MainShellState>(
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: state.currentIndex,
                onTap: context.read<MainShellCubit>().setTab,
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
              );
            },
          ),
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
