import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/core/resources/configs/app_theme.dart';
import 'package:my_portfolio/core/resources/configs/app_typography.dart';
import 'package:my_portfolio/core/resources/configs/space.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    required this.projectTitle,
    super.key,
    this.banner,
    this.projectIcon,
    this.projectIconData,
    this.onTap,
  });
  final String? banner;
  final String? projectIcon;
  final String projectTitle;
  final IconData? projectIconData;
  final VoidCallback? onTap;

  @override
  ProjectCardState createState() => ProjectCardState();
}

class ProjectCardState extends State<ProjectCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompactLayout = width <= 1135 && width >= 950;

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onTap,
      onHover: (isHovering) {
        if (isHovering) {
          setState(() {
            isHover = true;
          });
        } else {
          setState(() {
            isHover = false;
          });
        }
      },
      child: Container(
        margin: Space.h,
        padding: Space.all(),
        width: AppDimensions.normalize(155),
        height: AppDimensions.normalize(95),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isHover
              ? [
                  BoxShadow(
                    color: AppTheme.c!.primary!.withAlpha(100),
                    blurRadius: 12,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final cardHeight = constraints.maxHeight;
                final regularIconHeight = cardHeight * 0.42;
                final compactIconHeight = cardHeight * 0.16;
                final iconDataSize = cardHeight * 0.28;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space(0.4),
                    vertical: AppDimensions.space(0.25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.projectIcon != null)
                        if (isCompactLayout)
                          Row(
                            children: [
                              Image.asset(
                                widget.projectIcon!,
                                height: compactIconHeight,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox.shrink(),
                              ),
                              SizedBox(width: AppDimensions.space(0.3)),
                              Expanded(
                                child: Text(
                                  widget.projectTitle,
                                  style: AppText.b2b,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        else
                          Image.asset(
                            widget.projectIcon!,
                            height: regularIconHeight,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                      if (widget.projectIconData != null)
                        Icon(
                          widget.projectIconData,
                          color: AppTheme.c!.primary,
                          size: iconDataSize,
                        ),
                      if (!isCompactLayout) ...[
                        SizedBox(height: AppDimensions.space(0.35)),
                        Text(
                          widget.projectTitle,
                          style: AppText.b2b,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: isHover || widget.banner == null ? 0.0 : 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.banner != null
                    ? Image.asset(
                        widget.banner!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
