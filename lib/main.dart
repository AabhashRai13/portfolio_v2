import 'package:flutter/material.dart';
import 'package:my_portfolio/pages/home_page.dart';
import 'package:my_portfolio/resources/size_config.dart';
import 'styles/theme.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF2563EB),
      ),
      darkTheme: kCustomTheme,
      themeMode: ThemeMode.light,
      title: 'Aabhash Rai',
      home: const HomeMainPage(),
    );
  }
}
