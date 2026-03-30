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

  void _handleModelLoaded() {
    if (!mounted) return;
    if (widget.animationService.controller.onModelLoaded.value) {
      setState(() {
        _isModelLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.animationService.initialize();
    widget.animationService.controller.onModelLoaded.addListener(
      _handleModelLoaded,
    );
    _handleModelLoaded();
  }

  @override
  void dispose() {
    widget.animationService.controller.onModelLoaded.removeListener(
      _handleModelLoaded,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(200),
          width: getProportionateScreenWidth(200),
          child: Flutter3DViewer(
            activeGestureInterceptor: false,
            progressBarColor: Colors.transparent,
            enableTouch: false,
            controller: widget.animationService.controller,
            src: 'assets/3d_models/flutter_dash.glb',
          ),
        ),
        if (!_isModelLoaded)
          const SizedBox.shrink(), // Or use Container() for nothing at all
      ],
    );
  }
}
