/// About page copy, drafted from the résumé. Aabhash edits the bio before
/// this phase merges.
const String aboutBio =
    "I'm Aabhash, a mobile app developer in Sydney. For six years I've built "
    'iOS and Android apps for charities, hospitals, NGOs and startups, '
    'first in Kathmandu and now in Sydney. I care about the parts users '
    "never notice until they break: payments that don't fail, data that "
    'survives a bad connection, and releases that ship when promised. '
    'Lately I build native Android in Kotlin and Compose alongside Flutter.';

typedef SkillGroup = ({String title, String items});

const List<SkillGroup> skillGroups = [
  (
    title: 'Android / Native',
    items:
        'Kotlin, Jetpack Compose, Material 3, Hilt, Coroutines, Flow, Room, '
        'Retrofit, WorkManager, Gradle',
  ),
  (
    title: 'Cross-platform / iOS',
    items:
        'Flutter, Dart, BLoC, GetX, Provider, GoRouter, Isolates, iOS, Xcode, '
        'Fastlane',
  ),
  (
    title: 'Architecture, testing & delivery',
    items:
        'Clean Architecture, MVVM, Offline-first, Unit testing, Espresso, '
        'Robolectric, Kover, CI/CD, GitHub, Agile, Jira',
  ),
  (
    title: 'Backend, payments & data',
    items:
        'Firebase, Crashlytics, Supabase, Node.js, MongoDB, .NET, Stripe, '
        'Apple Pay, Google Pay',
  ),
];

typedef Job = ({String company, String role, String period, String location});

/// Mirrors the résumé (career-ops cv-aabhash-rai-portfolio.html).
const List<Job> experience = [
  (
    company: 'Sadaqa Welfare Fund',
    role: 'Software Developer',
    period: '10/2023 – Present',
    location: 'Sydney',
  ),
  (
    company: 'Babe, Get This',
    role: 'Native Android Engineer (self-directed)',
    period: '12/2025 – Present',
    location: 'Sydney',
  ),
  (
    company: 'Upwork',
    role: 'Freelance Software Developer',
    period: '06/2023 – 10/2023',
    location: 'Sydney',
  ),
  (
    company: 'PegoTec',
    role: 'Software Developer',
    period: '10/2021 – 01/2023',
    location: 'Remote (Singapore)',
  ),
  (
    company: 'TechAxis',
    role: 'Software Developer',
    period: '09/2022 – 01/2023',
    location: 'Kathmandu',
  ),
  (
    company: 'Prixa Technology',
    role: 'Software Developer',
    period: '02/2021 – 10/2021',
    location: 'Kathmandu',
  ),
  (
    company: 'Unlimited Technology',
    role: 'Software Developer',
    period: '03/2020 – 01/2021',
    location: 'Kathmandu',
  ),
];
