import 'package:flutter/material.dart';

class ContentPlaceholderPage extends StatelessWidget {
  const ContentPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Content routes are ready for future case studies and blog pages.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
