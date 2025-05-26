import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/skill_items.dart';
import 'package:my_portfolio/presentation/widgets/skill_orbit_animation.dart';

class SkillsDesktop extends StatelessWidget {
  const SkillsDesktop({super.key, this.mousePosition});
  final Offset? mousePosition;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.8,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SkillOrbitDemo(
              mousePosition: mousePosition,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 550,
            ),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
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
                          color: CustomColor.primary.withValues(alpha: 0.6),
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
                                CustomColor.pastelRed,
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
                            color: CustomColor.primary.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(
                              platformItems[i]['img'] as IconData,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title
                        Expanded(
                          child: Text(
                            platformItems[i]['title'] as String,
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
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get a contrasting background for pale icons
  Color getIconBgColor(Color iconColor) {
    // If the color is too light, use a darker tint
    final hsl = HSLColor.fromColor(iconColor);
    if (hsl.lightness > 0.7) {
      return iconColor.withValues(alpha: 0.25);
    }
    return iconColor.withValues(alpha: 0.12);
  }
}
