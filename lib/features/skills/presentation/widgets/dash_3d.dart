import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/features/skills/presentation/services/dash_3d_animation_service.dart';

class FlutterDash3D extends StatefulWidget {
  const FlutterDash3D({
    required this.animationService,
    super.key,
  });

  final Dash3DAnimationService animationService;

  @override
  State<FlutterDash3D> createState() => _FlutterDash3DState();
}

class _FlutterDash3DState extends State<FlutterDash3D> {
  bool _isModelLoaded = false;

  String get _modelSource {
    const assetPath = 'assets/3d_models/flutter_dash.glb';
    if (!kIsWeb) {
      return assetPath;
    }
    return Uri.base.resolve('/assets/$assetPath').toString();
  }

  void _handleModelLoaded(String _) {
    if (!mounted) return;
    widget.animationService.handleModelLoaded();
    setState(() {
      _isModelLoaded = true;
    });
  }

  void _handleModelError(String error) {
    debugPrint('FlutterDash3D failed to load model: $error');
  }

  @override
  void initState() {
    super.initState();
    widget.animationService.resetController();
  }

  @override
  void dispose() {
    widget.animationService.handleViewerDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(200),
          width: getProportionateScreenWidth(200),
          child: Flutter3DViewer(
            key: ValueKey<String>(_modelSource),
            activeGestureInterceptor: false,
            progressBarColor: Colors.transparent,
            enableTouch: false,
            controller: widget.animationService.controller,
            src: _modelSource,
            onLoad: _handleModelLoaded,
            onError: _handleModelError,
          ),
        ),
        if (!_isModelLoaded)
          const SizedBox.shrink(), // Or use Container() for nothing at all
      ],
      ),
    );
  }
}
