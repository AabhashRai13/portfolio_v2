import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/core/presentation/widgets/blog_top_navigation_bar.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/newsletter/presentation/controllers/newsletter_controller.dart';
import 'package:my_portfolio/features/newsletter/presentation/widgets/newsletter_hero.dart';
import 'package:my_portfolio/features/newsletter/presentation/widgets/newsletter_offer.dart';

/// Standalone landing page where visitors can subscribe to the newsletter.
class NewsletterPage extends StatefulWidget {
  const NewsletterPage({required this.newsletterController, super.key});

  final NewsletterController newsletterController;

  @override
  State<NewsletterPage> createState() => _NewsletterPageState();
}

class _NewsletterPageState extends State<NewsletterPage> {
  late final NewsletterController _newsletterController;

  @override
  void initState() {
    super.initState();
    _newsletterController = widget.newsletterController;
  }

  @override
  void dispose() {
    _newsletterController.dispose();
    super.dispose();
  }

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
              child: SingleChildScrollView(
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
                    const SizedBox(height: 64),
                    const NewsletterHero(),
                    const SizedBox(height: 44),
                    NewsletterOffer(controller: _newsletterController),
                    const SizedBox(height: 56),
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
