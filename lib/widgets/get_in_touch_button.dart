import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/resources/size_config.dart';

class GetInTouchButton extends StatelessWidget {
  const GetInTouchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (SizeConfig.screenWidth >= kMinDesktopWidth)
          ? SizeConfig.screenWidth * 0.25
          : SizeConfig.screenWidth * 0.8,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.primary,
          foregroundColor: CustomColor.textLight,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
        ),
        child: const Text("Get in touch"),
      ),
    );
  }
}
