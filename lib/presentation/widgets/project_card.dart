import 'package:flutter/material.dart';
import 'package:my_portfolio/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/resources/configs/app_theme.dart';
import 'package:my_portfolio/resources/configs/app_typography.dart';
import 'package:my_portfolio/resources/configs/space.dart';
import 'package:my_portfolio/services/url_launcher_services.dart';

class ProjectCard extends StatefulWidget {
  final String? banner;
  final String? projectLink;
  final String? projectIcon;
  final String projectTitle;
  final IconData? projectIconData;

  const ProjectCard({
    super.key,
    this.banner,
    this.projectIcon,
    this.projectLink,
    this.projectIconData,
    required this.projectTitle,
  });
  @override
  ProjectCardState createState() => ProjectCardState();
}

class ProjectCardState extends State<ProjectCard> {
  bool isHover = false;
  final UrlLauncherServices urlLauncherServices = UrlLauncherServices();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
        width: AppDimensions.normalize(145),
        height: AppDimensions.normalize(85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isHover
              ? [
                  BoxShadow(
                    color: AppTheme.c!.primary!.withAlpha(100),
                    blurRadius: 12.0,
                    offset: const Offset(0.0, 0.0),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 12.0,
                    offset: const Offset(0.0, 0.0),
                  )
                ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.projectIcon != null
                    ? (width > 1135 || width < 950)
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
                    : Container(),
                widget.projectIconData != null
                    ? Icon(
                        widget.projectIconData,
                        color: AppTheme.c!.primary!,
                        size: height * 0.1,
                      )
                    : Container(),
                (width > 1135 || width < 950)
                    ? SizedBox(
                        height: height * 0.02,
                      )
                    : const SizedBox(),
                (width > 1135 || width < 950)
                    ? Text(
                        widget.projectTitle,
                        style: AppText.b2b,
                        textAlign: TextAlign.center,
                      )
                    : Container(),
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
