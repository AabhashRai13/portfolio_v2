import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

// Apps built end to end by me, strongest first. These are the carousel.
const featuredProjects = <FeaturedProject>[
  FeaturedProject(
    title: 'Babe, Get This',
    about: 'Shared shopping list for couples.',
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
    icon: 'assets/projects/babe_get_this_icon.png',
    links: [
      'https://play.google.com/store/apps/details?id=com.babegetthis.android',
    ],
  ),
  FeaturedProject(
    title: 'Sadaqa',
    about: 'Donation and ticketing app for a charity.',
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
    icon: 'assets/projects/sadaqa_icon.png',
    links: [
      'https://apps.apple.com/us/app/sadaqa/id6474403245',
      'https://play.google.com/store/apps/details?id=org.sadaqa.sadaqa',
    ],
  ),
  FeaturedProject(
    title: 'Public IDPoor',
    about: 'Government social-support app in Cambodia.',
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
    icon: 'assets/projects/public_idpoor_icon.png',
    links: [
      'https://apps.apple.com/kh/app/public-idpoor/id1636608437?platform=iphone',
    ],
  ),
];

// Team projects: only in the All projects grid.
const otherProjects = <ProjectSummary>[
  ProjectSummary(
    title: 'Humanity & Inclusion EO',
    about: 'Explosive-ordnance guide for field teams.',
    icon: 'assets/projects/hi_eo_icon.png',
    links: ['https://apps.apple.com/au/app/hi-eo/id1672194507'],
  ),
  ProjectSummary(
    title: 'National Cardiac Centre',
    about: 'Connects heart patients with their doctors.',
    icon: 'assets/projects/ncc_icon.png',
    links: ['https://play.google.com/store/apps/details?id=org.prixa.ncc'],
  ),
  ProjectSummary(
    title: 'Our Rights',
    about: 'Labour-law guide for workers in Cambodia.',
    icon: 'assets/projects/our_rights_icon.png',
    links: [
      'https://play.google.com/store/apps/details?id=com.pegotec.ourrights',
    ],
  ),
  ProjectSummary(
    title: 'Fight On Mentality',
    about: 'Mindset coaching app.',
    icon: 'assets/projects/fom_icon.png',
    links: ['https://apps.apple.com/np/app/fight-on-mentality/id1643569350'],
  ),
  ProjectSummary(
    title: 'Pomelo HRM',
    about: 'HR app for teams and attendance.',
    icon: 'assets/projects/pom_icon.png',
    links: [
      'https://play.google.com/store/apps/details?id=org.pomeloHrmApp',
    ],
  ),
  ProjectSummary(
    title: 'Lokantar',
    about: 'Local news app.',
    icon: 'assets/projects/lokantar_icon.png',
    links: [
      'https://play.google.com/store/apps/details?id=org.prixa.lokaantar',
    ],
  ),
];
