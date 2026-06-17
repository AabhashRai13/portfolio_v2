import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Embeds [pdfUrl] in an `<iframe>` so the browser's native PDF viewer renders
/// it with built-in scroll and zoom.
class ResumePdfView extends StatefulWidget {
  const ResumePdfView({required this.pdfUrl, super.key});

  final String pdfUrl;

  @override
  State<ResumePdfView> createState() => _ResumePdfViewState();
}

class _ResumePdfViewState extends State<ResumePdfView> {
  // Each instance needs a unique view type; registering the same one twice
  // throws.
  static int _instances = 0;
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'resume-pdf-view-${_instances++}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => web.HTMLIFrameElement()
        ..src = widget.pdfUrl
        ..title = 'Resume PDF'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%',
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
