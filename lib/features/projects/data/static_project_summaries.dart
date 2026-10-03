import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

// Ordered strongest-first: the first cards are what visitors actually see.
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
    result: '12K+ downloads · 4.5★ · 60% of donations moved to the app',
    icon: 'assets/projects/sadaqa_icon.png',
    link: 'https://apps.apple.com/us/app/sadaqa/id6474403245',
    banner: 'assets/projects/sadaqa_poster.jpg',
  ),
  ProjectSummary(
    title: 'Humanity & Inclusion — EO Reference',
    summary:
        'Explosive-ordnance identification app for the field teams of '
        'Humanity & Inclusion, an international humanitarian NGO.',
    role: 'Mobile engineer · PegoTec',
    banner: 'assets/projects/hi_eo_poster.jpg',
    icon: 'assets/projects/hi_eo_icon.png',
    link: 'https://apps.apple.com/au/app/hi-eo/id1672194507',
  ),
  ProjectSummary(
    title: 'National Cardiac Centre',
    flagship: true,
    summary:
        'Patient app for a national heart hospital that connects '
        'patients directly with their doctors.',
    role: 'Mobile engineer · Prixa Technology',
    result: '10K+ downloads · 4.6★ on Google Play',
    banner: 'assets/projects/ncc_poster.jpg',
    icon: 'assets/projects/ncc_icon.png',
    link:
        'https://play.google.com/store/apps/details?id=org.prixa.ncc&hl=en&gl=US',
  ),
  ProjectSummary(
    title: 'Our Rights',
    flagship: true,
    summary:
        'Cambodian labour-law guide that helps workers understand '
        'their rights in plain language.',
    role: 'Mobile engineer · PegoTec',
    result: '10K+ downloads on Google Play',
    banner: 'assets/projects/our_rights_poster.jpg',
    icon: 'assets/projects/our_rights_icon.png',
    link: 'https://play.google.com/store/apps/details?id=com.pegotec.ourrights',
  ),
  ProjectSummary(
    title: 'Public IDPoor',
    summary:
        "Government app for Cambodia's Ministry of Planning that "
        'streamlines access to the IDPoor social-support program.',
    role: 'Mobile engineer · PegoTec',
    banner: 'assets/projects/public_idpoor.jpg',
    icon: 'assets/projects/public_idpoor_icon.png',
    link:
        'https://apps.apple.com/kh/app/public-idpoor/id1636608437?platform=iphone',
  ),
  ProjectSummary(
    title: 'Fight On Mentality',
    summary:
        'Mindset coaching app that helps users stay motivated and '
        'track their achievements.',
    banner: 'assets/projects/fom_poster.jpg',
    icon: 'assets/projects/fom_icon.png',
    link: 'https://apps.apple.com/np/app/fight-on-mentality/id1643569350',
  ),
  ProjectSummary(
    title: 'Pomelo HRM',
    summary: 'HR app for managing teams, attendance and workflows.',
    role: 'Mobile engineer · Prixa Technology',
    banner: 'assets/projects/pom_poster.jpg',
    icon: 'assets/projects/pom_icon.png',
    link:
        'https://play.google.com/store/apps/details?id=org.pomeloHrmApp&hl=en&gl=US',
  ),
  ProjectSummary(
    title: 'Lokantar',
    summary: 'News app for following local stories and current updates.',
    role: 'Mobile engineer · Prixa Technology',
    banner: 'assets/projects/lokantar_projects.jpg',
    icon: 'assets/projects/lokantar_icon.png',
    link: 'https://play.google.com/store/apps/details?id=org.prixa.lokaantar',
  ),
];
