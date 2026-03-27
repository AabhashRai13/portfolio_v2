import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/features/skills/presentation/services/dash_3d_animation_service.dart';

class FlutterDash3D extends StatefulWidget {
  const FlutterDash3D({super.key});

  @override
  State<FlutterDash3D> createState() => _FlutterDash3DState();
}

class _FlutterDash3DState extends State<FlutterDash3D> {
  final Dash3DAnimationService _dash3DAnimationService =
      Dash3DAnimationService();
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _dash3DAnimationService.initialize();
    _dash3DAnimationService.controller?.onModelLoaded.addListener(() {
      if (_dash3DAnimationService.controller?.onModelLoaded.value ?? false) {
        setState(() {
          _isModelLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _dash3DAnimationService.dispose();
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
            controller: _dash3DAnimationService.controller,
            src: 'assets/3d_models/flutter_dash.glb',
          ),
        ),
        if (!_isModelLoaded)
          const SizedBox.shrink(), // Or use Container() for nothing at all
      ],
    );
  }
}
