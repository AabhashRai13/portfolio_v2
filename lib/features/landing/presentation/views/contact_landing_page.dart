import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';
import 'package:my_portfolio/features/landing/presentation/views/landing_page.dart';

/// Route adapter that opens contact over the otherwise stateless landing page.
class ContactLandingPage extends StatefulWidget {
  const ContactLandingPage({super.key});

  @override
  State<ContactLandingPage> createState() => _ContactLandingPageState();
}

class _ContactLandingPageState extends State<ContactLandingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(_openContact()),
    );
  }

  Future<void> _openContact() async {
    await showContactPanel(context);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) => const LandingPage();
}
