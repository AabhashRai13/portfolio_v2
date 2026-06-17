import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/presentation/widgets/blog_top_navigation_bar.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/resume/presentation/controllers/resume_controller.dart';
import 'package:my_portfolio/features/resume/presentation/widgets/resume_header.dart';
import 'package:my_portfolio/features/resume/presentation/widgets/resume_pdf_view.dart';

/// Page that shows the resume PDF inline and offers download / contact actions.
class ResumePage extends StatelessWidget {
  const ResumePage({required this.resumeController, super.key});

  final ResumeController resumeController;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: palette.pageGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    BlogTopNavigationBar(
                      onOpenHome: () => context.go(AppRoutes.home),
                      onOpenBlogList: () => context.go(AppRoutes.blog),
                    ),
                    const SizedBox(height: 24),
                    ResumeHeader(controller: resumeController),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: palette.surfaceElevated,
                            border: Border.all(color: palette.borderSoft),
                          ),
                          child: const ResumePdfView(
                            pdfUrl: SnsLinks.resumePdf,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
