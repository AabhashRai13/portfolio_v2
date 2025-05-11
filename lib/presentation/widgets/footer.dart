import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        border: Border(
          top: BorderSide(
            color: CustomColor.primary.withOpacity(0.12),
            width: 2,
          ),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name and heart
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                "Made by ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: CustomColor.textSecondary,
                  fontSize: 16,
                ),
              ),
              Text(
                "Aabhash Rai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColor.primary,
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.favorite_rounded,
                color: Colors.redAccent,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                "with",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: CustomColor.textSecondary,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 6),
              FaIcon(
                FontAwesomeIcons.flutter,
                color: CustomColor.primary,
                size: 18,
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            "Built with Flutter 3.24",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: CustomColor.textSecondary,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
