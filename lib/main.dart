import 'package:flutter/widgets.dart';
import 'package:my_portfolio/app/app.dart';
import 'package:my_portfolio/app/di/service_locator.dart';

void main() async {
  setupDependencies();
  runApp(const PortfolioApp());
}
