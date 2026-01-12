import 'package:flutter/material.dart';

import 'constants/app_routes.dart';
import 'ui/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.locale,
    this.builder,
  });

  final Locale? locale;
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      locale: locale,
      builder: builder,
    );
  }
}

