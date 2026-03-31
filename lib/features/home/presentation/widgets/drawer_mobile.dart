import 'package:flutter/material.dart';

import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_item.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({
    required this.navigationItems,
    required this.onNavItemTap,
    super.key,
  });
  final List<HomeNavigationItem> navigationItems;
  final void Function(HomeNavigationItem) onNavItemTap;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColor.scaffoldBg,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
                bottom: 20,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          for (final item in navigationItems)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              titleTextStyle: const TextStyle(
                color: CustomColor.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              onTap: () {
                onNavItemTap(item);
              },
              leading: Icon(item.icon),
              title: Text(item.title),
            ),
        ],
      ),
    );
  }
}
