import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/app_images.dart';
import 'constants/app_sizes.dart';
import 'data/repositories/app_data_repositories.dart';
import 'data/repositories/participants_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/transactions_repository.dart';
import 'ui/theme/app_theme.dart';

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppDataRepositories>(
      future: AppDataRepositories.create(),
      builder: (context, snapshot) {
        final repos = snapshot.data;
        if (repos == null) {
          return const _BootstrapLoadingApp();
        }

        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ProfileRepository>.value(value: repos.profile),
            RepositoryProvider<ParticipantsRepository>.value(
              value: repos.participants,
            ),
            RepositoryProvider<TransactionsRepository>.value(
              value: repos.transactions,
            ),
            RepositoryProvider<SettingsRepository>.value(value: repos.settings),
          ],
          child: child,
        );
      },
    );
  }
}

class _BootstrapLoadingApp extends StatelessWidget {
  const _BootstrapLoadingApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const _BootstrapLoadingView(),
    );
  }
}

class _BootstrapLoadingView extends StatelessWidget {
  const _BootstrapLoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.splashBackground,
            fit: BoxFit.cover,
          ),
          const Align(
            alignment: Alignment(0, -0.25),
            child: SizedBox(
              height: AppSizes.splashLoaderSize,
              width: AppSizes.splashLoaderSize,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

