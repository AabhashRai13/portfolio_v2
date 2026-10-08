import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

// Only apps built end to end by me, strongest first.
const staticProjectSummaries = <ProjectSummary>[
  ProjectSummary(
    title: 'Babe, Get This',
    role: 'Solo developer · design to release',
    problem:
        'Shopping for two gets messy when the list lives in one '
        "person's head or a lost text thread.",
    built:
        'A native Android app with offline-first lists, sign-in, and voice '
        'notes that AI turns into named shopping lists.',
    result:
        'Live on Google Play, with unit, Compose and end-to-end tests that '
        'fail the build below 100% logic coverage.',
    stack: 'Kotlin · Jetpack Compose · Hilt · Room · Supabase',
    banner: 'assets/projects/babe_get_this_poster.jpg',
    links: [
      'https://play.google.com/store/apps/details?id=com.babegetthis.android',
    ],
  ),
  ProjectSummary(
    title: 'Sadaqa',
    role: 'Founding mobile engineer · first build to release',
    problem:
        'A Sydney charity could only take donations and sell event tickets '
        'through its website.',
    built:
        'An iOS and Android app with Stripe, Apple Pay and Google Pay, and '
        'real-time ticket booking.',
    result:
        '60% of donations moved from web to app, and ticket sales beat a 10K '
        'target with 13K⁠–⁠14K sold.',
    stack: 'Flutter · BLoC · Stripe · Firebase',
    banner: 'assets/projects/sadaqa_poster.jpg',
    links: [
      'https://apps.apple.com/us/app/sadaqa/id6474403245',
      'https://play.google.com/store/apps/details?id=org.sadaqa.sadaqa',
    ],
  ),
  ProjectSummary(
    title: 'Public IDPoor',
    role: 'Solo mobile developer · built from scratch',
    problem:
        'Cambodian households had to visit local offices to ask for an '
        'IDPoor interview or check their Equity Card.',
    built:
        "An app for Cambodia's Ministry of Planning: interview requests, "
        'objections and feedback, ID-card scanning and Equity Card checks.',
    result:
        'Started from an empty project and built every screen alone, on a '
        'clean architecture with BLoC.',
    stack: 'Flutter · BLoC · Clean Architecture',
    banner: 'assets/projects/idpoor_poster.jpg',
    links: [
      'https://apps.apple.com/kh/app/public-idpoor/id1636608437?platform=iphone',
    ],
  ),
];
