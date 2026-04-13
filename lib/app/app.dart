import 'package:flutter/material.dart';
import 'package:my_portfolio/app/router/app_router.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/core/services/smooth_wheel_scroll_controller.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const PortfolioScrollBehavior(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF2563EB),
      ),
      darkTheme: kCustomTheme,
      themeMode: ThemeMode.light,
      title: 'Aabhash Rai',
      routerConfig: AppRouter.router,
    );
  }
}
