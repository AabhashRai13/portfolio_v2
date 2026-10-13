import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

class CarouselPills extends StatelessWidget {
  const CarouselPills({
    required this.projects,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final List<FeaturedProject> projects;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < projects.length; i++)
          Semantics(
            button: true,
            selected: i == selected,
            label: 'Show ${projects[i].title}',
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapFeedback();
                onSelect(i);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 12,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: i == selected ? 44 : 26,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == selected
                          ? palette.textStrong
                          : palette.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
