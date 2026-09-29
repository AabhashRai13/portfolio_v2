import 'package:flutter/material.dart';

import 'package:my_portfolio/core/resources/styles/home_palette.dart';
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
    final palette = Theme.of(context).homePalette;
    return Drawer(
      backgroundColor: palette.sectionBackground,
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
                icon: Icon(Icons.close, color: palette.textStrong),
              ),
            ),
          ),
          for (final item in navigationItems)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              titleTextStyle: TextStyle(
                color: palette.textStrong,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              iconColor: palette.primaryAccent,
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
