import 'package:flutter/material.dart';
import 'package:my_portfolio/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/resources/configs/app_theme.dart';
import 'package:my_portfolio/resources/configs/app_typography.dart';
import 'package:my_portfolio/resources/configs/space.dart';
import 'package:my_portfolio/services/url_launcher_services.dart';


class ProjectCard extends StatefulWidget {

  const ProjectCard({
    required this.projectTitle,
    super.key,
    this.banner,
    this.projectIcon,
    this.projectLink,
    this.projectIconData,
  });
  final String? banner;
  final String? projectLink;
  final String? projectIcon;
  final String projectTitle;
  final IconData? projectIconData;

  @override
  ProjectCardState createState() => ProjectCardState();
}

class ProjectCardState extends State<ProjectCard> {
  bool isHover = false;
  final UrlLauncherServices urlLauncherServices = UrlLauncherServices();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.projectLink == null
          ? () {}
          : () => urlLauncherServices.openURL(
                widget.projectLink!,
              ),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.projectIcon != null)
                  (width > 1135 || width < 950)
                      ? Image.asset(
                          widget.projectIcon!,
                          height: height * 0.15,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              widget.projectIcon!,
                              height: height * 0.03,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Flexible(
                              child: Text(
                                widget.projectTitle,
                                style: AppText.b2b,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                else
                  Container(),
                if (widget.projectIconData != null)
                  Icon(
                    widget.projectIconData,
                    color: AppTheme.c!.primary,
                    size: height * 0.1,
                  )
                else
                  Container(),
                if (width > 1135 || width < 950)
                  SizedBox(
                    height: height * 0.02,
                  )
                else
                  const SizedBox(),
                if (width > 1135 || width < 950)
                  Text(
                    widget.projectTitle,
                    style: AppText.b2b,
                    textAlign: TextAlign.center,
                  )
                else
                  Container(),
                SizedBox(
                  height: height * 0.01,
                ),
              ],
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: isHover ? 0.0 : 1.0,
              child: FittedBox(
                fit: BoxFit.fill,
                child: widget.banner != null
                    ? Image.asset(
                        widget.banner!,
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
