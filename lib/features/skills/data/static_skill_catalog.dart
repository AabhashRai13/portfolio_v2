import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/features/skills/domain/models/platform_capability.dart';
import 'package:my_portfolio/features/skills/domain/models/skill_badge.dart';

const platformCapabilities = <PlatformCapability>[
  PlatformCapability(
    icon: FontAwesomeIcons.android,
    title: 'Android',
  ),
  PlatformCapability(
    icon: FontAwesomeIcons.globe,
    title: 'Web',
  ),
  PlatformCapability(
    icon: FontAwesomeIcons.apple,
    title: 'IOS',
  ),
  PlatformCapability(
    icon: FontAwesomeIcons.server,
    title: 'Backend',
  ),
];

const skillBadges = <SkillBadge>[
  SkillBadge(
    icon: FontAwesomeIcons.flutter,
    title: 'Flutter',
    color: Colors.blue,
  ),
  SkillBadge(
    icon: FontAwesomeIcons.fire,
    title: 'Firebase',
    color: Color(0xFFFFCA28),
  ),
  SkillBadge(
    icon: FontAwesomeIcons.js,
    title: 'JavaScript',
    color: Colors.yellow,
  ),
  SkillBadge(
    icon: FontAwesomeIcons.python,
    title: 'Python',
    color: Color(0xFFFFDE57),
  ),
  SkillBadge(
    icon: FontAwesomeIcons.android,
    title: 'Android',
    color: Color(0xFFA4C639),
  ),
  SkillBadge(
    icon: FontAwesomeIcons.apple,
    title: 'Apple',
    color: Color(0xFF1D1D1F),
  ),
  SkillBadge(
    icon: FontAwesomeIcons.nodeJs,
    title: 'Node.js',
    color: Colors.green,
  ),
  SkillBadge(
    icon: FontAwesomeIcons.stripe,
    title: 'Stripe',
    color: Color(0xFF635BFF),
  ),
  SkillBadge(
    icon: FontAwesomeIcons.googlePay,
    title: 'Google Pay',
    color: Color(0xFF4285F4),
  ),
  SkillBadge(
    icon: FontAwesomeIcons.applePay,
    title: 'Apple Pay',
    color: Color(0xFF000000),
  ),
];
