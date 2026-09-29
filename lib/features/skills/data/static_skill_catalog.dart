import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/fa_icons.dart';
import 'package:my_portfolio/features/skills/domain/models/platform_capability.dart';
import 'package:my_portfolio/features/skills/domain/models/skill_badge.dart';

const platformCapabilities = <PlatformCapability>[
  PlatformCapability(
    icon: FaIcons.android,
    title: 'Android',
  ),
  PlatformCapability(
    icon: FaIcons.globe,
    title: 'Web',
  ),
  PlatformCapability(
    icon: FaIcons.apple,
    title: 'IOS',
  ),
  PlatformCapability(
    icon: FaIcons.server,
    title: 'Backend',
  ),
];

const skillBadges = <SkillBadge>[
  SkillBadge(
    icon: FaIcons.flutter,
    title: 'Flutter',
    color: Colors.blue,
  ),
  SkillBadge(
    icon: FaIcons.fire,
    title: 'Firebase',
    color: Color(0xFFFFCA28),
  ),
  SkillBadge(
    icon: FaIcons.js,
    title: 'JavaScript',
    color: Colors.yellow,
  ),
  SkillBadge(
    icon: FaIcons.python,
    title: 'Python',
    color: Color(0xFFFFDE57),
  ),
  SkillBadge(
    icon: FaIcons.android,
    title: 'Android',
    color: Color(0xFFA4C639),
  ),
  SkillBadge(
    icon: FaIcons.apple,
    title: 'Apple',
    color: Color(0xFF1D1D1F),
  ),
  SkillBadge(
    icon: FaIcons.nodeJs,
    title: 'Node.js',
    color: Colors.green,
  ),
  SkillBadge(
    icon: FaIcons.stripe,
    title: 'Stripe',
    color: Color(0xFF635BFF),
  ),
  SkillBadge(
    icon: FaIcons.googlePay,
    title: 'Google Pay',
    color: Color(0xFF4285F4),
  ),
  SkillBadge(
    icon: FaIcons.applePay,
    title: 'Apple Pay',
    color: Color(0xFF000000),
  ),
];
