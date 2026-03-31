import 'package:flutter/widgets.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_target.dart';

class HomeNavigationItem {
  const HomeNavigationItem({
    required this.title,
    required this.icon,
    required this.target,
  });

  final String title;
  final IconData icon;
  final HomeNavigationTarget target;
}
