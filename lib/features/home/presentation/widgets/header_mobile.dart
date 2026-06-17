import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/core/resources/styles/style.dart';

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({
    required this.onOpenNewsletter,
    super.key,
    this.onMenuTap,
  });
  final VoidCallback onOpenNewsletter;
  final VoidCallback? onMenuTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: kHeaderDecoration,
      // The hero carries the name now; the old logo slot holds the newsletter
      // entry point instead.
      child: Row(
        children: [
          const SizedBox(width: 8),
          TextButton(
            onPressed: onOpenNewsletter,
            style: TextButton.styleFrom(
              foregroundColor: CustomColor.textPrimary,
            ),
            child: const Text('Newsletter'),
          ),
          const Spacer(),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
