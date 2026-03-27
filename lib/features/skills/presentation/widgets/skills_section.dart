import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/home/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/features/skills/presentation/services/dash_3d_animation_service.dart';
import 'package:my_portfolio/features/skills/presentation/widgets/skills_desktop.dart';
import 'package:my_portfolio/features/skills/presentation/widgets/skills_mobile.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({
    required this.isDesktop,
    required this.width,
    super.key,
  });

  final bool isDesktop;
  final double width;

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final Dash3DAnimationService _dash3DAnimationService =
      Dash3DAnimationService();

  @override
  void dispose() {
    _dash3DAnimationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) =>
          _dash3DAnimationService.handleMouseMove(event, context),
      onExit: _dash3DAnimationService.handleMouseExit,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        color: CustomColor.bgLight1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomSectionHeading(
              text: 'What I Can Do',
              icon: Icons.computer,
              subText: 'My Mastery Arsenal.',
            ),
            const SizedBox(height: 50),
            if (widget.isDesktop)
              const SkillsDesktop()
            else
              const SkillsMobile(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
