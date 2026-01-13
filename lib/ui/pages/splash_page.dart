import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_images.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../data/repositories/settings_repository.dart';
import 'splash_cubit.dart';
import 'splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SplashCubit(settings: context.read<SettingsRepository>());
    unawaited(_cubit.bootstrap());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == SplashStatus.navigate,
        listener: (context, state) {
          final next = state.nextRoute;
          if (next == null) return;
          Navigator.of(context).pushReplacementNamed(next);
        },
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            _Background(),
            _Loader(),
          ],
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.splashBackground,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const ColoredBox(
        color: Colors.black,
        child: Center(child: Text(AppStrings.splashTitle)),
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: AppSizes.splashLoaderSize,
        width: AppSizes.splashLoaderSize,
        child: Lottie.asset(
          AppImages.splashLoaderAnimation,
          fit: BoxFit.contain,
          repeat: true,
          errorBuilder: (_, __, ___) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
