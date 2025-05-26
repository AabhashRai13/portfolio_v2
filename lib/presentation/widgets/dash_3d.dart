import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:my_portfolio/presentation/services/mouse_pointer_animation_service.dart';
import 'package:my_portfolio/resources/size_config.dart';

class FlutterDash3D extends StatefulWidget {
  const FlutterDash3D({super.key, this.mousePosition});
  final Offset? mousePosition;

  @override
  State<FlutterDash3D> createState() => _FlutterDash3DState();
}

class _FlutterDash3DState extends State<FlutterDash3D> {
  final MousePointerAnimation _mousePointerAnimation = MousePointerAnimation();
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _mousePointerAnimation.initialize();
    _mousePointerAnimation.controller?.onModelLoaded.addListener(() {
      if (_mousePointerAnimation.controller?.onModelLoaded.value??false) {
        setState(() {
          _isModelLoaded = true;
        });
      }
    });
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
            controller: _mousePointerAnimation.controller,
            src: 'assets/3d_models/flutter_dash.glb',
          ),
        ),
        if (!_isModelLoaded)
          const SizedBox.shrink(), // Or use Container() for nothing at all
      ],
    );
  }
}
