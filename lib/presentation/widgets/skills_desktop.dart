import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';
import '../../constants/skill_items.dart';

class SkillsDesktop extends StatelessWidget {
  const SkillsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // platforms
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 550,
          ),
          child: Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: [
              for (int i = 0; i < platformItems.length; i++)
                Container(
                  width: 210,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColor.primary.withOpacity(0.6),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Accent bar
                      Container(
                        width: 6,
                        height: 56,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              CustomColor.primary,
                              CustomColor.pastelRed
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Circular icon
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: CustomColor.primary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FaIcon(
                            platformItems[i]["img"],
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title
                      Expanded(
                        child: Text(
                          platformItems[i]["title"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: CustomColor.textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                )
            ],
          ),
        ),
        const SizedBox(width: 50),

        // skills
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                for (int i = 0; i < skillItems.length; i++)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColor.primary.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: skillItems[i]["color"].withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon with circular background
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: getIconBgColor(skillItems[i]["color"]),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(
                              skillItems[i]["icon"],
                              color: skillItems[i]["color"],
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Skill title
                        Center(
                          child: Text(
                            skillItems[i]["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: CustomColor.textPrimary,
                              letterSpacing: 0.2,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Helper to get a contrasting background for pale icons
  Color getIconBgColor(Color iconColor) {
    // If the color is too light, use a darker tint
    final hsl = HSLColor.fromColor(iconColor);
    if (hsl.lightness > 0.7) {
      return iconColor.withOpacity(0.25);
    }
    return iconColor.withOpacity(0.12);
  }
}
