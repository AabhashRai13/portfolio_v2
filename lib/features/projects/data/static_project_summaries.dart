import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

// Only apps built end to end by me, strongest first.
const staticProjectSummaries = <ProjectSummary>[
  ProjectSummary(
    title: 'Babe, Get This',
    flagship: true,
    summary:
        'Shared shopping list for couples, grouped by store, with quantities, '
        'notes and pick-up progress.',
    role: 'Solo developer · native Android in Kotlin and Jetpack Compose',
    banner: 'assets/projects/babe_get_this_poster.jpg',
    link:
        'https://play.google.com/store/apps/details?id=com.babegetthis.android',
  ),
  ProjectSummary(
    title: 'Sadaqa',
    flagship: true,
    summary:
        'Donation and event-ticketing app for a Sydney charity, with Stripe, '
        'Apple Pay and Google Pay.',
    role: 'Founding mobile engineer · Sadaqa Welfare Fund',
    icon: 'assets/projects/sadaqa_icon.png',
    link: 'https://apps.apple.com/us/app/sadaqa/id6474403245',
    banner: 'assets/projects/sadaqa_poster.jpg',
  ),
  ProjectSummary(
    title: 'Public IDPoor',
    flagship: true,
    summary:
        "Government app for Cambodia's Ministry of Planning that "
        'streamlines access to the IDPoor social-support program.',
    role: 'Mobile engineer · PegoTec',
    banner: 'assets/projects/idpoor_poster.jpg',
    icon: 'assets/projects/public_idpoor_icon.png',
    link:
        'https://apps.apple.com/kh/app/public-idpoor/id1636608437?platform=iphone',
  ),
];
