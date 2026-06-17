import 'package:flutter/material.dart';

/// Non-web fallback. This app ships to the web, where the iframe-based viewer
/// is used instead; this exists only so the code compiles on other platforms.
class ResumePdfView extends StatelessWidget {
  const ResumePdfView({required this.pdfUrl, super.key});

  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('The resume preview is available on the web.'),
    );
  }
}
