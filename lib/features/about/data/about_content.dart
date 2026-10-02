import 'package:flutter/widgets.dart';
import 'package:my_portfolio/core/resources/fa_icons.dart';

/// About page copy. The video carries the story; these lines only frame it
/// for founders and hiring teams.
const List<String> aboutStatement = [_statementLead, _statementOwnership];
const String _statementLead =
    "For six years I've taken mobile apps from first idea to the App Store and "
    'Google Play.';
const String _statementOwnership =
    'I own the whole build, from first screen to launch and every update '
    'after, so you can stay focused on the business.';

const String availability = 'Open to freelance projects and full-time roles';

/// Qualifies visitors: who works well with Aabhash.
const List<String> goodFit = [
  'Want to move fast without lowering the bar.',
  'Want someone who just gets it done, no hand-holding.',
  'Care what happens after launch: crashes, reviews, updates.',
  _fitPlatformHurdles,
];
const String _fitPlatformHurdles =
    'Want platform hurdles flagged early, with a plan B ready, such as what '
    'iOS and Android widgets allow.';

typedef ProcessStep = ({String title, String body});

const List<ProcessStep> howIWork = [
  (
    title: 'Discuss',
    body:
        'We talk through the business problem and agree on the best way to '
        'solve it. Already have a plan? I pick it up from there.',
  ),
  (
    title: 'Build',
    body:
        'I keep you posted as I build, and we talk through decisions as they '
        'come up. You always know where things stand.',
  ),
  (
    title: 'Release & support',
    body: 'I ship to both stores, then stay on for support and updates.',
  ),
];

/// A skill draws either a Font Awesome `icon` or a monochrome PNG `asset`
/// (Simple Icons, CC0) for brands Font Awesome lacks. Both are tinted.
typedef Skill = ({String label, IconData? icon, String? asset});

const List<Skill> skills = [
  (label: 'iOS', icon: FaIcons.apple, asset: null),
  (label: 'Android', icon: FaIcons.android, asset: null),
  (label: 'Kotlin', icon: null, asset: 'assets/images/skill_kotlin.png'),
  (
    label: 'Jetpack Compose',
    icon: null,
    asset: 'assets/images/skill_jetpackcompose.png',
  ),
  (label: 'Flutter', icon: FaIcons.flutter, asset: null),
  (label: 'Firebase', icon: null, asset: 'assets/images/skill_firebase.png'),
  (label: 'Stripe', icon: FaIcons.stripe, asset: null),
  (label: 'Apple Pay', icon: FaIcons.applePay, asset: null),
  (label: 'Google Pay', icon: FaIcons.googlePay, asset: null),
  (label: 'Node.js', icon: FaIcons.nodeJs, asset: null),
  (label: 'Testing', icon: FaIcons.vial, asset: null),
  (label: 'CI/CD', icon: FaIcons.codeBranch, asset: null),
];
