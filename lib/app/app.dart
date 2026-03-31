import 'package:flutter/material.dart';
import 'package:my_portfolio/app/router/app_router.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
