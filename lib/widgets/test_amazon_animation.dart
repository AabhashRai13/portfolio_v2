import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skills Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Skills'),
      ),
      body: const Center(
        child: SkillsAnimation(),
      ),
    );
  }
}

class SkillsAnimation extends StatefulWidget {
  const SkillsAnimation({super.key});

  @override
  State<SkillsAnimation> createState() => _SkillsAnimationState();
}

class _SkillsAnimationState extends State<SkillsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SkillIcon> _skillIcons = [];
  final int _numberOfIcons = 8;
  final double _orbitRadius = 120.0;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize skill icons with random parameters
    final random = math.Random();
    for (int i = 0; i < _numberOfIcons; i++) {
      _skillIcons.add(
        SkillIcon(
          icon: _getSkillIcon(i),
          speed: 0.5 +
              random.nextDouble() * 0.5, // Random speed between 0.5 and 1.0
          startAngle:
              random.nextDouble() * 2 * math.pi, // Random start position
          orbitRadius: _orbitRadius *
              (0.7 + random.nextDouble() * 0.6), // Random orbit size
          orbitEccentricity:
              0.2 + random.nextDouble() * 0.4, // Random orbit shape
        ),
      );
    }
  }

  IconData _getSkillIcon(int index) {
    // You can replace these with your actual skill icons
    final icons = [
      Icons.flutter_dash, // Flutter
      Icons.code, // Node
      Icons.local_fire_department, // Firebase
      Icons.language, // Web
      Icons.storage, // Database
      Icons.cloud, // Cloud
      Icons.mobile_friendly, // Mobile
      Icons.design_services, // Design
    ];

    return icons[index % icons.length];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Your profile image in the center
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                  'assets/profile_image.jpg'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Animated skill icons
        ..._skillIcons.map((skillIcon) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final angle = skillIcon.startAngle +
                  _controller.value * 2 * math.pi * skillIcon.speed;

              // Calculate position using parametric equation of an ellipse
              final x = skillIcon.orbitRadius *
                  math.cos(angle) *
                  skillIcon.orbitEccentricity;
              final y = skillIcon.orbitRadius * math.sin(angle);

              return Transform.translate(
                offset: Offset(x, y),
                child: child!,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                skillIcon.icon,
                size: 24,
                color: Colors.blue,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class SkillIcon {
  final IconData icon;
  final double speed;
  final double startAngle;
  final double orbitRadius;
  final double orbitEccentricity;

  SkillIcon({
    required this.icon,
    required this.speed,
    required this.startAngle,
    required this.orbitRadius,
    required this.orbitEccentricity,
  });
}
