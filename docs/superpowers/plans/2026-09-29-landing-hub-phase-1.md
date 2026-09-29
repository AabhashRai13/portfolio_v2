# Landing Hub Phase 1 (Structure and Cleanup) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the long-scroll home page with a routed site: a temporary type-only landing at `/`, new `/work`, `/about` and `/contact` routes, a shared top bar and contact panel, bundled fonts, and removal of the game, 3D Dash, skills orbit and other dead weight.

**Architecture:** go_router routes per destination, all wrapped in the existing `AppThemeScope`. Shared site chrome (navigation helpers, top bar, text link, page scaffold, footer) lives in `lib/app/navigation/`. Contact opens as a panel (side dialog on desktop, bottom sheet on mobile) from any page, and `/contact` opens it over the landing. Phase 2 adds the phone and live widgets to the landing; this phase only builds the structure they plug into.

**Tech Stack:** Flutter 3.47.5 (web), go_router 16, get_it 8, youtube_player_iframe 5, flutter_test.

**Spec:** `docs/superpowers/specs/2026-09-29-landing-hub-redesign-design.md` (Phase 1 of "Phases").

## Global Constraints

- Run Flutter through the pinned SDK: `.fvm/flutter_sdk/bin/flutter` (3.47.5). After any `pub get`, run `git checkout pubspec.lock` only if you did not intend to change dependencies.
- `lib/keys.dart` is a gitignored local placeholder with empty strings. It must exist for the app to compile. Never commit it.
- Copy positions Aabhash as a mobile app developer. Never write "Flutter developer" in user-facing copy.
- No AI-template patterns: no eyebrow kickers, availability pills, stat rows, gradient blobs or glass cards.
- Keep the current palettes in `lib/core/resources/styles/home_palette.dart`. New colours become `HomePalette` fields, never hard-coded literals in widgets.
- Desktop/mobile breakpoint: `kSiteDesktopBreakpoint = 1000` (logical px).
- Tap targets are at least 48 px. Nothing may depend on hover alone.
- Every page must render without overflow at 375×812, 390×844, 768×1024 and 1440×900.
- Work happens on branch `feat/landing_hub`. The PR targets `development`, never `main`.
- End every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## File Map

Created:
- `assets/fonts/ArchivoExtraCondensed-Black.ttf`, `assets/fonts/ArchivoCondensed-ExtraBold.ttf`, `assets/fonts/IBMPlexMono-Medium.ttf`, and `assets/fonts/licenses/` (OFL texts, not shipped).
- `assets/images/intro_video_thumb.jpg`: bundled intro-video still.
- `lib/core/resources/styles/site_text.dart`: display, tagline, label and body text styles.
- `lib/app/navigation/site_navigation.dart`: `SiteSection`, `openSiteSection`, `openResume`, `openExternal`.
- `lib/app/navigation/site_text_link.dart`: mono caps link.
- `lib/app/navigation/site_top_bar.dart`: inner-page top bar and mobile menu.
- `lib/app/navigation/site_page.dart`: inner-page scaffold (top bar, title, content, footer).
- `lib/app/navigation/site_footer.dart`: moved from `lib/features/home/presentation/widgets/footer.dart`.
- `lib/features/contact/presentation/views/contact_panel.dart`: `showContactPanel`.
- `lib/features/about/data/about_content.dart`: bio, skills and experience data.
- `lib/features/about/presentation/widgets/intro_video.dart`: thumbnail-first YouTube player.
- `lib/features/about/presentation/views/about_page.dart`.
- `lib/features/projects/presentation/controllers/work_controller.dart`.
- `lib/features/projects/presentation/views/work_page.dart`.
- `lib/features/landing/presentation/views/landing_page.dart`.
- Tests: `test/helpers/site_test_harness.dart`, `test/core/resources/styles/home_palette_test.dart`, `test/features/contact/presentation/contact_panel_test.dart`, `test/app/navigation/site_top_bar_test.dart`, `test/features/about/presentation/about_page_test.dart`, `test/features/projects/presentation/work_page_test.dart`, `test/features/landing/presentation/landing_page_test.dart`, `test/app/router/app_router_test.dart`.

Modified:
- `pubspec.yaml`, `lib/core/resources/styles/home_palette.dart`, `lib/constants/size.dart`, `lib/constants/sns_links.dart`, `lib/app/router/app_routes.dart`, `lib/app/router/app_router.dart`, `lib/app/di/service_locator.dart`, `lib/features/contact/presentation/views/contact_section_view.dart`, `lib/core/resources/fa_icons.dart`, `web/index.html`.
- Blog pages: `lib/features/blog_list/presentation/views/blog_list_page.dart`, `lib/features/blog_detail/presentation/views/blog_post_detail_page.dart`, `lib/features/newsletter/presentation/views/newsletter_page.dart`.

Deleted in Task 8:
- `lib/features/game/`, `lib/features/skills/`, `lib/features/home/`.
- The three portfolio section widgets.
- `asset_manager.dart`, `blog_top_navigation_bar.dart`, `animated_logo.dart`.
- The game, home and bounce-man images, and `assets/3d_models/`.
- Dependencies `flame`, `flutter_3d_controller` and `carousel_slider`.

---

### Task 1: Fonts, tagline colour and site text styles

**Files:**
- Create: `assets/fonts/*.ttf`, `assets/fonts/licenses/Archivo-OFL.txt`, `assets/fonts/licenses/IBMPlexMono-OFL.txt`, `lib/core/resources/styles/site_text.dart`
- Modify: `pubspec.yaml` (flutter section), `lib/core/resources/styles/home_palette.dart`
- Test: `test/core/resources/styles/home_palette_test.dart`

**Interfaces:**
- Produces: `HomePalette.taglineText` (`Color`); `SiteText.display(Color, {required double size})`, `SiteText.tagline(Color, {required double size})`, `SiteText.label(Color, {double size = 13})`, `SiteText.body(Color, {double size = 18})`, all returning `TextStyle`; font families `ArchivoExtraCondensed` (w900), `ArchivoCondensed` (w800), `IBMPlexMono` (w500).

- [ ] **Step 1: Write the failing test**

Create `test/core/resources/styles/home_palette_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

void main() {
  test('tagline text uses the deep tan in light and dark', () {
    expect(HomePalette.light.taglineText, const Color(0xFFB08968));
    expect(HomePalette.dark.taglineText, const Color(0xFFD4B896));
  });

  test('lerp and copyWith carry taglineText', () {
    final mid = HomePalette.light.lerp(HomePalette.dark, 0.5);
    expect(
      mid.taglineText,
      Color.lerp(const Color(0xFFB08968), const Color(0xFFD4B896), 0.5),
    );

    final copy = HomePalette.light.copyWith(
      taglineText: const Color(0xFF000000),
    );
    expect(copy.taglineText, const Color(0xFF000000));
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `.fvm/flutter_sdk/bin/flutter test test/core/resources/styles/home_palette_test.dart`
Expected: compilation error, "The getter 'taglineText' isn't defined".

- [ ] **Step 3: Add `taglineText` to `HomePalette`**

In `lib/core/resources/styles/home_palette.dart`:

1. In the constructor, after `required this.shadowColor,`, add `required this.taglineText,`.
2. After the `shadowColor` field, add:
```dart
  /// Landing tagline: deep tan that still meets 3:1 on the page background.
  final Color taglineText;
```
3. In `static const HomePalette light`, after `shadowColor: Color(0xFF000000),`, add `taglineText: Color(0xFFB08968),`.
4. In `static const HomePalette dark`, after `shadowColor: Color(0xFF000000),`, add `taglineText: Color(0xFFD4B896),`.
5. In `copyWith`, add the parameter `Color? taglineText,` after `Color? shadowColor,`, and the argument `taglineText: taglineText ?? this.taglineText,` after `shadowColor: shadowColor ?? this.shadowColor,`.
6. In `lerp`, after the `shadowColor:` line, add `taglineText: Color.lerp(taglineText, other.taglineText, t)!,`.

- [ ] **Step 4: Run the test to verify it passes**

Run: `.fvm/flutter_sdk/bin/flutter test test/core/resources/styles/home_palette_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: Download the fonts and their licences**

Run from the repo root:

```bash
mkdir -p assets/fonts/licenses
dl() { u=$(curl -s -A "Wget/1.21" "https://fonts.googleapis.com/css2?family=$1" | grep -o 'https://[^)]*' | head -1); curl -s "$u" -o "assets/fonts/$2"; }
dl 'Archivo:wdth,wght@62.5,900' ArchivoExtraCondensed-Black.ttf
dl 'Archivo:wdth,wght@75,800' ArchivoCondensed-ExtraBold.ttf
dl 'IBM+Plex+Mono:wght@500' IBMPlexMono-Medium.ttf
curl -s https://raw.githubusercontent.com/google/fonts/main/ofl/archivo/OFL.txt -o assets/fonts/licenses/Archivo-OFL.txt
curl -s https://raw.githubusercontent.com/google/fonts/main/ofl/ibmplexmono/OFL.txt -o assets/fonts/licenses/IBMPlexMono-OFL.txt
file assets/fonts/*.ttf
```

Expected: three lines ending in `TrueType Font data`, each file about 110–130 KB. The Google Fonts CSS API serves TrueType to a non-browser user agent. The width must be `62.5`, because `62` returns no URL.

- [ ] **Step 6: Declare the fonts in `pubspec.yaml`**

Inside the `flutter:` section, directly after the `assets:` list, add:

```yaml
  fonts:
    - family: ArchivoExtraCondensed
      fonts:
        - asset: assets/fonts/ArchivoExtraCondensed-Black.ttf
          weight: 900
    - family: ArchivoCondensed
      fonts:
        - asset: assets/fonts/ArchivoCondensed-ExtraBold.ttf
          weight: 800
    - family: IBMPlexMono
      fonts:
        - asset: assets/fonts/IBMPlexMono-Medium.ttf
          weight: 500
```

- [ ] **Step 7: Create `lib/core/resources/styles/site_text.dart`**

```dart
import 'package:flutter/painting.dart';

/// Type styles for the landing hub and inner pages. Families are bundled in
/// `assets/fonts/` (see pubspec), not fetched at runtime.
abstract final class SiteText {
  static const String displayFamily = 'ArchivoExtraCondensed';
  static const String taglineFamily = 'ArchivoCondensed';
  static const String monoFamily = 'IBMPlexMono';

  /// Huge condensed caps: the name and page titles.
  static TextStyle display(Color color, {required double size}) => TextStyle(
    fontFamily: displayFamily,
    fontWeight: FontWeight.w900,
    fontSize: size,
    height: 0.92,
    letterSpacing: -0.01 * size,
    color: color,
  );

  /// Slightly wider condensed caps for the tagline.
  static TextStyle tagline(Color color, {required double size}) => TextStyle(
    fontFamily: taglineFamily,
    fontWeight: FontWeight.w800,
    fontSize: size,
    height: 1,
    color: color,
  );

  /// Small tracked mono caps: labels, links, captions.
  static TextStyle label(Color color, {double size = 13}) => TextStyle(
    fontFamily: monoFamily,
    fontWeight: FontWeight.w500,
    fontSize: size,
    letterSpacing: size * 0.18,
    color: color,
  );

  /// Readable body copy in the app's default text font.
  static TextStyle body(Color color, {double size = 18}) =>
      TextStyle(fontSize: size, height: 1.6, color: color);
}
```

- [ ] **Step 8: Verify and commit**

Run:
```bash
.fvm/flutter_sdk/bin/flutter pub get && .fvm/flutter_sdk/bin/flutter analyze && .fvm/flutter_sdk/bin/flutter test
```
Expected: `No issues found!` and `All tests passed!`.

```bash
git add assets/fonts pubspec.yaml lib/core/resources/styles/home_palette.dart lib/core/resources/styles/site_text.dart test/core/resources/styles/home_palette_test.dart
git commit -m "feat(site): bundle Archivo and IBM Plex Mono, add tagline colour and site text styles

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Site navigation helpers, test harness and contact panel

**Files:**
- Create: `lib/app/navigation/site_navigation.dart`, `lib/features/contact/presentation/views/contact_panel.dart`, `test/helpers/site_test_harness.dart`
- Modify: `lib/constants/size.dart`, `lib/constants/sns_links.dart`, `lib/app/router/app_routes.dart`, `lib/features/contact/presentation/views/contact_section_view.dart`
- Test: `test/features/contact/presentation/contact_panel_test.dart`

**Interfaces:**
- Consumes: `SiteText` and `HomePalette` from Task 1.
- Produces:
  - `kSiteDesktopBreakpoint` (`double`, 1000) in `constants/size.dart`.
  - `AppRoutes.work`, `AppRoutes.about`, `AppRoutes.contact`.
  - `SnsLinks.email`, `SnsLinks.introVideo`.
  - `enum SiteSection { work, about, writing, contact }`, each with `label` and `route`.
  - `void openSiteSection(BuildContext, SiteSection)`, `Future<void> openResume()`, `Future<void> openExternal(String url)`.
  - `Future<void> showContactPanel(BuildContext)`.
  - `ContactSection(controller:, embedded: bool)`.
  - Test helpers `registerSiteFakes()` (returns `Future<FakeLaunchService>`), `setViewSize(WidgetTester, Size)` and `pumpRouted(WidgetTester, Widget home)`. `pumpRouted` stub routes render `Text('page <path>')`.

- [ ] **Step 1: Add constants and routes**

Append to `lib/constants/size.dart`:
```dart

/// Widths at or above this get desktop layouts (phone mockup, full top bar).
const double kSiteDesktopBreakpoint = 1000;
```

In `lib/constants/sns_links.dart`, add inside `SnsLinks` after `instagram`:
```dart
  static const String email = 'raiaabhash3@gmail.com';
  static const String introVideo =
      'https://www.youtube.com/watch?v=jRT0dsBE3Tg';
```

In `lib/app/router/app_routes.dart`, add after `static const String home = '/';`:
```dart
  static const String work = '/work';
  static const String about = '/about';
  static const String contact = '/contact';
```

- [ ] **Step 2: Create the test harness `test/helpers/site_test_harness.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/core/controllers/app_theme_controller.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/core/services/theme_preference_store.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/projects/data/repositories/static_projects_repository.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

class FakeLaunchService implements AppLaunchService {
  final List<String> opened = <String>[];

  @override
  Future<void> openExternalUrl(String url) async => opened.add(url);
}

/// Keeps theme mode in memory instead of browser localStorage.
class MemoryThemeStore extends ThemePreferenceStore {
  ThemeMode _mode = ThemeMode.light;

  @override
  ThemeMode read() => _mode;

  @override
  void write(ThemeMode mode) => _mode = mode;
}

class _NoopContactRepository implements ContactRepository {
  @override
  Future<void> submitContactMessage(ContactMessage message) async {}
}

/// Registers the minimum getIt dependencies site widgets resolve.
Future<FakeLaunchService> registerSiteFakes() async {
  await getIt.reset();
  final launch = FakeLaunchService();
  getIt
    ..registerSingleton<AppLaunchService>(launch)
    ..registerSingleton<AppThemeController>(
      AppThemeController(store: MemoryThemeStore()),
    )
    ..registerSingleton<ProjectsRepository>(StaticProjectsRepository())
    ..registerFactory<ContactController>(
      () => ContactController(
        contactRepository: _NoopContactRepository(),
        launchService: launch,
      ),
    );
  return launch;
}

void setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps [home] at `/` with stub pages for every other site route.
Future<void> pumpRouted(WidgetTester tester, Widget home) async {
  final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (_, _) => home),
      for (final path in const ['/work', '/about', '/blog', '/contact'])
        GoRoute(
          path: path,
          builder: (_, _) => Scaffold(body: Text('page $path')),
        ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(theme: kLightTheme, routerConfig: router),
  );
  await tester.pumpAndSettle();
}
```

- [ ] **Step 3: Write the failing panel test `test/features/contact/presentation/contact_panel_test.dart`**

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  Future<void> openPanel(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kLightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => unawaited(showContactPanel(context)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('desktop opens a side panel with the form and closes it', (
    tester,
  ) async {
    setViewSize(tester, const Size(1440, 900));
    await openPanel(tester);

    expect(find.text('CONTACT'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);
    expect(find.text('Get In Touch'), findsNothing);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Send Message'), findsNothing);
  });

  testWidgets('mobile opens a bottom sheet with the form', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await openPanel(tester);

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/contact/presentation/contact_panel_test.dart`
Expected: compilation error, `contact_panel.dart` does not exist.

- [ ] **Step 5: Add `embedded` to `ContactSection`**

In `lib/features/contact/presentation/views/contact_section_view.dart`, make these four exact replacements:

1. Constructor and field. Replace:
```dart
  const ContactSection({
    required this.controller,
    super.key,
  });

  final ContactController controller;
```
with:
```dart
  const ContactSection({
    required this.controller,
    this.embedded = false,
    super.key,
  });

  final ContactController controller;

  /// Drops the section background, card and heading so the form can sit
  /// inside the contact panel, which provides its own chrome.
  final bool embedded;
```
2. Outer container. Replace:
```dart
        color: palette.sectionBackground,
        padding: const EdgeInsets.symmetric(vertical: 60),
```
with:
```dart
        color: widget.embedded ? null : palette.sectionBackground,
        padding: widget.embedded
            ? const EdgeInsets.symmetric(horizontal: 24)
            : const EdgeInsets.symmetric(vertical: 60),
```
3. Card. Replace:
```dart
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
            decoration: BoxDecoration(
```
with:
```dart
            padding: widget.embedded
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
            decoration: widget.embedded
                ? null
                : BoxDecoration(
```
4. Heading. Replace:
```dart
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
```
with:
```dart
              children: [
                if (!widget.embedded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
```
and replace:
```dart
                const SizedBox(height: 30),
                LayoutBuilder(
```
with:
```dart
                const SizedBox(height: 30),
                ],
                LayoutBuilder(
```

Then run `.fvm/flutter_sdk/bin/dart format lib/features/contact/presentation/views/contact_section_view.dart`.

- [ ] **Step 6: Create `lib/features/contact/presentation/views/contact_panel.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_section_view.dart';

const double _panelWidth = 420;

/// Opens the contact form over the current page: a right-hand panel on
/// desktop, a bottom sheet below [kSiteDesktopBreakpoint]. Completes when it
/// closes.
Future<void> showContactPanel(BuildContext context) async {
  final controller = getIt<ContactController>();
  final isDesktop = MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint;

  try {
    if (isDesktop) {
      await showGeneralDialog<void>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Close contact',
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, _, _) => Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: _panelWidth,
            height: double.infinity,
            child: _ContactPanelBody(controller: controller),
          ),
        ),
        transitionBuilder: (context, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    } else {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.92,
          child: _ContactPanelBody(controller: controller),
        ),
      );
    }
  } finally {
    controller.dispose();
  }
}

class _ContactPanelBody extends StatelessWidget {
  const _ContactPanelBody({required this.controller});

  final ContactController controller;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    // Own messenger + scaffold so the form's snackbars appear inside the
    // panel instead of behind the modal barrier. The scaffold also resizes
    // for the mobile keyboard.
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: palette.sectionBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'CONTACT',
                        style: SiteText.display(palette.textStrong, size: 44),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      icon: Icon(
                        Icons.close_rounded,
                        color: palette.textSecondary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ContactSection(
                    controller: controller,
                    embedded: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Create `lib/app/navigation/site_navigation.dart`**

```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';

/// The landing hub's destinations, in display order.
enum SiteSection {
  work('Work', AppRoutes.work),
  about('About', AppRoutes.about),
  writing('Writing', AppRoutes.blog),
  contact('Contact', AppRoutes.contact);

  const SiteSection(this.label, this.route);

  final String label;
  final String route;
}

/// Contact opens as a panel over the current page; the rest are routes.
void openSiteSection(BuildContext context, SiteSection section) {
  if (section == SiteSection.contact) {
    unawaited(showContactPanel(context));
    return;
  }
  context.go(section.route);
}

Future<void> openResume() => openExternal(SnsLinks.resume);

Future<void> openExternal(String url) =>
    getIt<AppLaunchService>().openExternalUrl(url);
```

- [ ] **Step 8: Run the panel test and the full suite**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/contact/presentation/contact_panel_test.dart && .fvm/flutter_sdk/bin/flutter test && .fvm/flutter_sdk/bin/flutter analyze`
Expected: both panel tests pass, the full suite passes (including `test/widget_test.dart`, which still finds `Get In Touch`), and `No issues found!`.

- [ ] **Step 9: Commit**

```bash
git add lib/constants lib/app/router/app_routes.dart lib/app/navigation/site_navigation.dart lib/features/contact test/helpers test/features/contact/presentation/contact_panel_test.dart
git commit -m "feat(site): site navigation helpers and contact panel

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: Site text link, top bar, page scaffold and footer

**Files:**
- Create: `lib/app/navigation/site_text_link.dart`, `lib/app/navigation/site_top_bar.dart`, `lib/app/navigation/site_page.dart`
- Move: `lib/features/home/presentation/widgets/footer.dart` → `lib/app/navigation/site_footer.dart` (class `Footer` → `SiteFooter`)
- Modify: `lib/features/home/presentation/views/home_main_page.dart` (footer import and usage only)
- Test: `test/app/navigation/site_top_bar_test.dart`

**Interfaces:**
- Consumes: `SiteSection`, `openSiteSection`, `openResume` (Task 2); `SiteText` and `HomePalette` (Task 1).
- Produces:
  - `SiteTextLink({required String label, required VoidCallback onTap, double fontSize = 13})`. It renders `label.toUpperCase()`.
  - `const SiteTopBar()`.
  - `SitePage({required String title, required Widget child, String? intro})` with `static const Key titleKey`. The title renders uppercased.
  - `const SiteFooter()`.

- [ ] **Step 1: Write the failing test `test/app/navigation/site_top_bar_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_top_bar.dart';

import '../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  const bar = Scaffold(body: SiteTopBar());

  testWidgets('desktop shows every destination and navigates', (
    tester,
  ) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    for (final label in ['WORK', 'ABOUT', 'WRITING', 'CONTACT', 'RÉSUMÉ']) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text('ABOUT'));
    await tester.pumpAndSettle();
    expect(find.text('page /about'), findsOneWidget);
  });

  testWidgets('résumé opens the hosted PDF', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    await tester.tap(find.text('RÉSUMÉ'));
    expect(launch.opened, ['/resume.pdf']);
  });

  testWidgets('contact opens the panel, not a route', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    await tester.tap(find.text('CONTACT'));
    await tester.pumpAndSettle();
    expect(find.text('Send Message'), findsOneWidget);
  });

  testWidgets('mobile moves links into a menu sheet', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, bar);

    expect(find.text('WORK'), findsNothing);
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('WORK'));
    await tester.pumpAndSettle();
    expect(find.text('page /work'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `.fvm/flutter_sdk/bin/flutter test test/app/navigation/site_top_bar_test.dart`
Expected: compilation error, `site_top_bar.dart` does not exist.

- [ ] **Step 3: Create `lib/app/navigation/site_text_link.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Understated mono caps link used across the site. Keyboard focusable,
/// at least 48 px tall, coral on hover or focus.
class SiteTextLink extends StatefulWidget {
  const SiteTextLink({
    required this.label,
    required this.onTap,
    this.fontSize = 13,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final double fontSize;

  @override
  State<SiteTextLink> createState() => _SiteTextLinkState();
}

class _SiteTextLinkState extends State<SiteTextLink> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return Semantics(
      link: true,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (value) => setState(() => _active = value),
        onFocusChange: (value) => setState(() => _active = value),
        borderRadius: BorderRadius.circular(6),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              widthFactor: 1,
              child: Text(
                widget.label.toUpperCase(),
                style: SiteText.label(
                  _active ? palette.secondaryAccent : palette.textStrong,
                  size: widget.fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create `lib/app/navigation/site_top_bar.dart`**

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Slim bar for inner pages: name (home), destinations, résumé, theme.
/// Below [kSiteDesktopBreakpoint] the links move into a bottom-sheet menu.
class SiteTopBar extends StatelessWidget {
  const SiteTopBar({super.key});

  static const String _resumeChoice = 'resume';

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint;

    return Row(
      children: [
        Semantics(
          link: true,
          label: 'Home',
          child: InkWell(
            onTap: () => context.go(AppRoutes.home),
            borderRadius: BorderRadius.circular(6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Center(
                widthFactor: 1,
                child: Text(
                  'AABHASH RAI',
                  style: SiteText.display(palette.textStrong, size: 28),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        if (isDesktop) ...[
          for (final section in SiteSection.values)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SiteTextLink(
                label: section.label,
                onTap: () => openSiteSection(context, section),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: SiteTextLink(
              label: 'Résumé',
              onTap: () => unawaited(openResume()),
            ),
          ),
        ],
        ThemeToggleButton(iconColor: palette.textSecondary),
        if (!isDesktop)
          IconButton(
            tooltip: 'Menu',
            icon: Icon(Icons.menu_rounded, color: palette.textStrong),
            onPressed: () => unawaited(_showMenu(context)),
          ),
      ],
    );
  }

  Future<void> _showMenu(BuildContext context) async {
    final palette = Theme.of(context).homePalette;
    final choice = await showModalBottomSheet<Object>(
      context: context,
      backgroundColor: palette.sectionBackground,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final section in SiteSection.values)
                SiteTextLink(
                  label: section.label,
                  fontSize: 16,
                  onTap: () => Navigator.of(sheetContext).pop(section),
                ),
              SiteTextLink(
                label: 'Résumé',
                fontSize: 16,
                onTap: () => Navigator.of(sheetContext).pop(_resumeChoice),
              ),
            ],
          ),
        ),
      ),
    );

    // Act after the sheet closes, from the page's context.
    if (!context.mounted) return;
    if (choice is SiteSection) openSiteSection(context, choice);
    if (choice == _resumeChoice) await openResume();
  }
}
```

- [ ] **Step 5: Move the footer**

```bash
git mv lib/features/home/presentation/widgets/footer.dart lib/app/navigation/site_footer.dart
```

In `lib/app/navigation/site_footer.dart`, rename `class Footer extends StatelessWidget` to `class SiteFooter extends StatelessWidget` and `const Footer({super.key});` to `const SiteFooter({super.key});`.

In `lib/features/home/presentation/views/home_main_page.dart`, replace the import `import 'package:my_portfolio/features/home/presentation/widgets/footer.dart';` with `import 'package:my_portfolio/app/navigation/site_footer.dart';`, and replace `child: Footer(),` with `child: SiteFooter(),`.

- [ ] **Step 6: Create `lib/app/navigation/site_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_footer.dart';
import 'package:my_portfolio/app/navigation/site_top_bar.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Shared scaffold for inner pages: top bar, big title, content, footer.
class SitePage extends StatelessWidget {
  const SitePage({
    required this.title,
    required this.child,
    this.intro,
    super.key,
  });

  static const Key titleKey = ValueKey<String>('site-page-title');

  final String title;
  final String? intro;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SiteTopBar(),
                        SizedBox(height: isNarrow ? 32 : 56),
                        Semantics(
                          header: true,
                          child: Text(
                            title.toUpperCase(),
                            key: titleKey,
                            style: SiteText.display(
                              palette.textStrong,
                              size: isNarrow ? 64 : 104,
                            ),
                          ),
                        ),
                        if (intro != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            intro!,
                            style: SiteText.body(palette.textSecondary),
                          ),
                        ],
                        SizedBox(height: isNarrow ? 32 : 48),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
              const SiteFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Run the tests and analyzer**

Run: `.fvm/flutter_sdk/bin/flutter test test/app/navigation/site_top_bar_test.dart && .fvm/flutter_sdk/bin/flutter test && .fvm/flutter_sdk/bin/flutter analyze`
Expected: all 4 top-bar tests pass, the full suite passes, and `No issues found!`.

- [ ] **Step 8: Commit**

```bash
git add lib/app/navigation lib/features/home test/app/navigation
git commit -m "feat(site): shared top bar, text link, page scaffold and footer

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: About page

**Files:**
- Create: `assets/images/intro_video_thumb.jpg`, `lib/features/about/data/about_content.dart`, `lib/features/about/presentation/widgets/intro_video.dart`, `lib/features/about/presentation/views/about_page.dart`
- Test: `test/features/about/presentation/about_page_test.dart`

**Interfaces:**
- Consumes: `SitePage` with `titleKey`, `SiteTextLink`, `openResume`, `openExternal`, `SnsLinks.introVideo`, `SiteText`, `HomePalette`.
- Produces: `const AboutPage()`; `const IntroVideo()`; `aboutBio` (`String`); `skillGroups` (`List<SkillGroup>`, where `SkillGroup = ({String title, String items})`); `experience` (`List<Job>`, where `Job = ({String company, String role, String period, String location})`).

- [ ] **Step 1: Write the failing test `test/features/about/presentation/about_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/features/about/presentation/views/about_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  for (final size in const [Size(375, 812), Size(1440, 900)]) {
    testWidgets('renders video, bio, skills and experience at $size', (
      tester,
    ) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const AboutPage());

      expect(tester.widget<Text>(find.byKey(SitePage.titleKey)).data, 'ABOUT');
      expect(find.byTooltip('Play intro video'), findsOneWidget);
      expect(find.text('WATCH ON YOUTUBE ↗'), findsOneWidget);
      expect(find.textContaining("I'm Aabhash"), findsOneWidget);
      expect(find.text('SKILLS'), findsOneWidget);
      expect(find.text('EXPERIENCE'), findsOneWidget);
      expect(find.text('Sadaqa Welfare Fund'), findsOneWidget);
    });
  }

  testWidgets('download résumé opens the PDF', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const AboutPage());

    final link = find.text('DOWNLOAD RÉSUMÉ ↗');
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    expect(launch.opened, ['/resume.pdf']);
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/about/presentation/about_page_test.dart`
Expected: compilation error, `about_page.dart` does not exist.

- [ ] **Step 3: Bundle the video thumbnail**

```bash
curl -sL https://i3.ytimg.com/vi/jRT0dsBE3Tg/maxresdefault.jpg -o "$TMPDIR/intro_thumb_src.jpg"
sips -s format jpeg -s formatOptions 80 -Z 1280 "$TMPDIR/intro_thumb_src.jpg" --out assets/images/intro_video_thumb.jpg
sips -g pixelWidth -g pixelHeight assets/images/intro_video_thumb.jpg
```
Expected: `pixelWidth: 1280`, `pixelHeight: 720`. It is bundled because CanvasKit cannot draw a cross-origin YouTube image without CORS headers.

- [ ] **Step 4: Create `lib/features/about/data/about_content.dart`**

```dart
/// About page copy, drafted from the résumé. Aabhash edits the bio before
/// this phase merges.
const String aboutBio =
    "I'm Aabhash, a mobile engineer in Sydney. For six years I've built "
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
```

- [ ] **Step 5: Create `lib/features/about/presentation/widgets/intro_video.dart`**

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Thumbnail first; the YouTube iframe (a platform view) is created only when
/// play is pressed, so the page pays for the player only when it is wanted.
/// The YouTube link below doubles as the fallback if the player fails.
class IntroVideo extends StatefulWidget {
  const IntroVideo({super.key});

  static const String videoId = 'jRT0dsBE3Tg';
  static const String thumbnail = 'assets/images/intro_video_thumb.jpg';

  @override
  State<IntroVideo> createState() => _IntroVideoState();
}

class _IntroVideoState extends State<IntroVideo> {
  YoutubePlayerController? _controller;

  void _play() {
    final controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showVideoAnnotations: false,
        strictRelatedVideos: true,
      ),
    );
    unawaited(controller.loadVideoById(videoId: IntroVideo.videoId));
    setState(() => _controller = controller);
  }

  @override
  void dispose() {
    unawaited(_controller?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: controller == null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(IntroVideo.thumbnail, fit: BoxFit.cover),
                      Center(
                        child: IconButton(
                          tooltip: 'Play intro video',
                          iconSize: 72,
                          icon: const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                          ),
                          onPressed: _play,
                        ),
                      ),
                    ],
                  )
                : YoutubePlayerScaffold(
                    controller: controller,
                    builder: (context, player) => player,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SiteTextLink(
          label: 'Watch on YouTube ↗',
          onTap: () => unawaited(openExternal(SnsLinks.introVideo)),
        ),
      ],
    );
  }
}
```

- [ ] **Step 6: Create `lib/features/about/presentation/views/about_page.dart`**

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/about/data/about_content.dart';
import 'package:my_portfolio/features/about/presentation/widgets/intro_video.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return SitePage(
      title: 'About',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IntroVideo(),
          const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              aboutBio,
              style: SiteText.body(palette.textStrong, size: 20),
            ),
          ),
          const SizedBox(height: 56),
          const _Heading('Skills'),
          for (final group in skillGroups) ...[
            Text(
              group.title.toUpperCase(),
              style: SiteText.label(palette.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(group.items, style: SiteText.body(palette.textStrong)),
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 36),
          const _Heading('Experience'),
          for (final job in experience) _JobRow(job: job),
          const SizedBox(height: 40),
          SiteTextLink(
            label: 'Download résumé ↗',
            fontSize: 15,
            onTap: () => unawaited(openResume()),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Semantics(
        header: true,
        child: Text(
          text.toUpperCase(),
          style: SiteText.display(palette.textStrong, size: 48),
        ),
      ),
    );
  }
}

class _JobRow extends StatelessWidget {
  const _JobRow({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: palette.primaryAccent.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 6,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                job.company,
                style: SiteText.body(
                  palette.textStrong,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '${job.role} · ${job.location}',
                style: SiteText.body(palette.textSecondary, size: 15),
              ),
            ],
          ),
          Text(job.period, style: SiteText.label(palette.textSecondary)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: Run the tests and analyzer**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/about && .fvm/flutter_sdk/bin/flutter analyze`
Expected: 3 tests pass and `No issues found!`.

- [ ] **Step 8: Commit**

```bash
git add assets/images/intro_video_thumb.jpg lib/features/about test/features/about
git commit -m "feat(about): about page with lazy intro video, bio, skills and experience

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: Work page (interim) and WorkController

**Files:**
- Create: `lib/features/projects/presentation/controllers/work_controller.dart`, `lib/features/projects/presentation/views/work_page.dart`
- Modify: `lib/app/di/service_locator.dart`, `test/helpers/site_test_harness.dart`
- Test: `test/features/projects/presentation/work_page_test.dart`

**Interfaces:**
- Consumes: `SitePage`, `SiteTextLink`, `ProjectCard({required ProjectSummary project, VoidCallback? onTap})` (existing), `ProjectsRepository`, `AppLaunchService`, `StaticUtils.gitHub` (existing).
- Produces:
  - `WorkController({required AppLaunchService launchService, required ProjectsRepository projectsRepository})` with `List<ProjectSummary> projects`, `Future<void> openProject(ProjectSummary)` and `Future<void> openSource()`.
  - `WorkPage({required WorkController controller})`.
  - `WorkController` registered as a getIt factory, in the app and in `registerSiteFakes`.

- [ ] **Step 1: Write the failing test `test/features/projects/presentation/work_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/features/projects/data/static_project_summaries.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/work_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  for (final size in const [Size(375, 812), Size(1440, 900)]) {
    testWidgets('lists every project at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, WorkPage(controller: getIt<WorkController>()));

      expect(tester.widget<Text>(find.byKey(SitePage.titleKey)).data, 'WORK');
      for (final project in staticProjectSummaries) {
        expect(find.text(project.title), findsOneWidget);
      }
    });
  }

  testWidgets('tapping a project opens its store link', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, WorkPage(controller: getIt<WorkController>()));

    final title = find.text(staticProjectSummaries.first.title);
    await tester.ensureVisible(title);
    await tester.pumpAndSettle();
    await tester.tap(title);
    expect(launch.opened, [staticProjectSummaries.first.link]);
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/projects/presentation/work_page_test.dart`
Expected: compilation error, `work_controller.dart` does not exist.

- [ ] **Step 3: Create `lib/features/projects/presentation/controllers/work_controller.dart`**

```dart
import 'package:my_portfolio/core/resources/utils/static_utils.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

class WorkController {
  WorkController({
    required AppLaunchService launchService,
    required ProjectsRepository projectsRepository,
  }) : _launchService = launchService,
       _projectsRepository = projectsRepository;

  final AppLaunchService _launchService;
  final ProjectsRepository _projectsRepository;

  late final List<ProjectSummary> projects = _projectsRepository
      .getFeaturedProjects();

  Future<void> openProject(ProjectSummary project) =>
      _launchService.openExternalUrl(project.link);

  Future<void> openSource() =>
      _launchService.openExternalUrl(StaticUtils.gitHub);
}
```

- [ ] **Step 4: Create `lib/features/projects/presentation/views/work_page.dart`**

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/core/resources/configs/app.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_card.dart';

/// Interim Work page: the existing project cards. Phase 4 replaces this with
/// the flagship layout for Babe, Get This and Sadaqa.
class WorkPage extends StatelessWidget {
  const WorkPage({required this.controller, super.key});

  final WorkController controller;

  @override
  Widget build(BuildContext context) {
    // ProjectCard sizes itself from the legacy App/AppDimensions config.
    App.init(context);

    return SitePage(
      title: 'Work',
      intro: 'Apps I have helped design, build and ship.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              for (final project in controller.projects)
                ProjectCard(
                  project: project,
                  onTap: () => unawaited(controller.openProject(project)),
                ),
            ],
          ),
          const SizedBox(height: 40),
          SiteTextLink(
            label: 'Source code on GitHub ↗',
            onTap: () => unawaited(controller.openSource()),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Register `WorkController`**

In `lib/app/di/service_locator.dart`, add the import `import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';`, and add after the `HomeController` factory registration:
```dart
    ..registerFactory(
      () => WorkController(
        launchService: getIt.get<AppLaunchService>(),
        projectsRepository: getIt.get<ProjectsRepository>(),
      ),
    )
```

In `test/helpers/site_test_harness.dart`, add the import `import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';`, and append to the `getIt` cascade in `registerSiteFakes` (before the final `;`):
```dart
    ..registerFactory<WorkController>(
      () => WorkController(
        launchService: launch,
        projectsRepository: getIt<ProjectsRepository>(),
      ),
    )
```

- [ ] **Step 6: Run the tests and analyzer**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/projects && .fvm/flutter_sdk/bin/flutter analyze`
Expected: 3 tests pass and `No issues found!`.

- [ ] **Step 7: Commit**

```bash
git add lib/features/projects lib/app/di/service_locator.dart test/helpers test/features/projects
git commit -m "feat(work): interim work page and WorkController

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Temporary landing page

**Files:**
- Create: `lib/features/landing/presentation/views/landing_page.dart`
- Test: `test/features/landing/presentation/landing_page_test.dart`

**Interfaces:**
- Consumes: `SiteSection`, `openSiteSection`, `openResume`, `openExternal`, `SiteTextLink`, `showContactPanel`, `SiteText`, `HomePalette.taglineText`, `kSiteDesktopBreakpoint`, `SnsLinks.email`.
- Produces: `LandingPage({bool openContactOnStart = false})`. Phase 2 inserts the phone and widget grid between the name and the tagline.

- [ ] **Step 1: Write the failing test `test/features/landing/presentation/landing_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/landing/presentation/views/landing_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  const tagline = 'I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS';

  for (final size in const [Size(375, 812), Size(768, 1024), Size(1440, 900)]) {
    testWidgets('shows name, tagline and every link at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const LandingPage());

      expect(find.text('AABHASH RAI'), findsOneWidget);
      expect(find.text(tagline), findsOneWidget);
      for (final label in ['WORK', 'ABOUT', 'WRITING', 'CONTACT', 'RÉSUMÉ']) {
        expect(find.text(label), findsOneWidget);
      }
    });
  }

  testWidgets('work link navigates to /work', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const LandingPage());

    await tester.tap(find.text('WORK'));
    await tester.pumpAndSettle();
    expect(find.text('page /work'), findsOneWidget);
  });

  testWidgets('contact link opens the panel', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, const LandingPage());

    await tester.tap(find.text('CONTACT'));
    await tester.pumpAndSettle();
    expect(find.text('Send Message'), findsOneWidget);
  });

  testWidgets('openContactOnStart opens the panel on load', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const LandingPage(openContactOnStart: true));

    expect(find.text('Send Message'), findsOneWidget);
    expect(find.text(tagline), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/landing/presentation/landing_page_test.dart`
Expected: compilation error, `landing_page.dart` does not exist.

- [ ] **Step 3: Create `lib/features/landing/presentation/views/landing_page.dart`**

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';

/// Landing hub. Phase 1 is type and links only; Phase 2 adds the phone and
/// live widgets between the name and the tagline.
class LandingPage extends StatefulWidget {
  const LandingPage({this.openContactOnStart = false, super.key});

  /// True for `/contact`: open the contact panel over the landing on load.
  final bool openContactOnStart;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    if (widget.openContactOnStart) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(_openContact()),
      );
    }
  }

  Future<void> _openContact() async {
    await showContactPanel(context);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint;

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            'SYDNEY, AUSTRALIA',
                            style: SiteText.label(palette.textSecondary),
                          ),
                          Text(
                            '·',
                            style: SiteText.label(palette.textSecondary),
                          ),
                          SiteTextLink(
                            label: SnsLinks.email,
                            onTap: () => unawaited(
                              openExternal('mailto:${SnsLinks.email}'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isDesktop ? 24 : 16),
                      Semantics(
                        header: true,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'AABHASH RAI',
                            style: SiteText.display(
                              palette.textStrong,
                              size: isDesktop ? 168 : 112,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 28 : 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Text(
                          'I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS',
                          textAlign: TextAlign.center,
                          style: SiteText.tagline(
                            palette.taglineText,
                            size: isDesktop ? 72 : 36,
                          ),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 40 : 28),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          for (final section in SiteSection.values)
                            SiteTextLink(
                              label: section.label,
                              onTap: () => openSiteSection(context, section),
                            ),
                          SiteTextLink(
                            label: 'Résumé',
                            onTap: () => unawaited(openResume()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: ThemeToggleButton(iconColor: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run the tests and analyzer**

Run: `.fvm/flutter_sdk/bin/flutter test test/features/landing && .fvm/flutter_sdk/bin/flutter analyze`
Expected: 6 tests pass (3 sizes plus 3 behaviours) and `No issues found!`.

- [ ] **Step 5: Commit**

```bash
git add lib/features/landing test/features/landing
git commit -m "feat(landing): temporary type-only landing with links and /contact support

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 7: Router wiring and blog top bar swap

**Files:**
- Modify: `lib/app/router/app_router.dart`, `lib/features/blog_list/presentation/views/blog_list_page.dart`, `lib/features/blog_detail/presentation/views/blog_post_detail_page.dart`, `lib/features/newsletter/presentation/views/newsletter_page.dart`
- Test: `test/app/router/app_router_test.dart`

**Interfaces:**
- Consumes: `LandingPage`, `WorkPage`, `WorkController` (getIt), `AboutPage`, `SiteTopBar`, `AppRoutes.work/about/contact`.
- Produces: `AppRouter.createRouter({String initialLocation = AppRoutes.home})`; `AppRouter.router` now equals `createRouter()`.

- [ ] **Step 1: Write the failing test `test/app/router/app_router_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/router/app_router.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';

import '../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  Future<void> pumpAt(WidgetTester tester, String location) async {
    setViewSize(tester, const Size(1440, 900));
    final router = AppRouter.createRouter(initialLocation: location);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: kLightTheme, routerConfig: router),
    );
    await tester.pumpAndSettle();
  }

  String? pageTitle(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(SitePage.titleKey)).data;

  testWidgets('/ shows the landing', (tester) async {
    await pumpAt(tester, '/');
    expect(find.text('AABHASH RAI'), findsOneWidget);
    expect(find.byKey(SitePage.titleKey), findsNothing);
  });

  testWidgets('/work shows the work page', (tester) async {
    await pumpAt(tester, '/work');
    expect(pageTitle(tester), 'WORK');
  });

  testWidgets('/about shows the about page', (tester) async {
    await pumpAt(tester, '/about');
    expect(pageTitle(tester), 'ABOUT');
  });

  testWidgets('/contact opens the panel over the landing', (tester) async {
    await pumpAt(tester, '/contact');
    expect(find.text('Send Message'), findsOneWidget);
    expect(
      find.text('I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS'),
      findsOneWidget,
    );
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `.fvm/flutter_sdk/bin/flutter test test/app/router/app_router_test.dart`
Expected: compilation error, "Member not found: 'AppRouter.createRouter'".

- [ ] **Step 3: Rewrite `lib/app/router/app_router.dart`**

```dart
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/core/presentation/widgets/app_theme_scope.dart';
import 'package:my_portfolio/features/about/presentation/views/about_page.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_detail/presentation/views/blog_post_detail_page.dart';
import 'package:my_portfolio/features/blog_list/presentation/controllers/blog_list_controller.dart';
import 'package:my_portfolio/features/blog_list/presentation/views/blog_list_page.dart';
import 'package:my_portfolio/features/landing/presentation/views/landing_page.dart';
import 'package:my_portfolio/features/newsletter/presentation/controllers/newsletter_controller.dart';
import 'package:my_portfolio/features/newsletter/presentation/views/newsletter_page.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/work_page.dart';

class AppRouter {
  static final GoRouter router = createRouter();

  static GoRouter createRouter({String initialLocation = AppRoutes.home}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) =>
              const AppThemeScope(child: LandingPage()),
        ),
        GoRoute(
          path: AppRoutes.work,
          builder: (context, state) => AppThemeScope(
            child: WorkPage(controller: getIt.get<WorkController>()),
          ),
        ),
        GoRoute(
          path: AppRoutes.about,
          builder: (context, state) => const AppThemeScope(child: AboutPage()),
        ),
        GoRoute(
          path: AppRoutes.contact,
          builder: (context, state) => const AppThemeScope(
            child: LandingPage(openContactOnStart: true),
          ),
        ),
        GoRoute(
          path: AppRoutes.blog,
          builder: (context, state) => AppThemeScope(
            child: BlogListPage(
              blogListController: getIt.get<BlogListController>(),
            ),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.blogDetailSegment,
              builder: (context, state) => AppThemeScope(
                child: BlogPostDetailPage(
                  slug: state.pathParameters['slug']!,
                  blogPostDetailController:
                      getIt.get<BlogPostDetailController>(),
                  newsletterController: getIt.get<NewsletterController>(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.newsletter,
          builder: (context, state) => AppThemeScope(
            child: NewsletterPage(
              newsletterController: getIt.get<NewsletterController>(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.content,
          redirect: (context, state) => AppRoutes.home,
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Swap the blog pages to `SiteTopBar`**

In `lib/features/blog_list/presentation/views/blog_list_page.dart`, replace:
```dart
                      BlogTopNavigationBar(
                        onOpenHome: () => context.go(AppRoutes.home),
                        onOpenNewsletter: () =>
                            context.go(AppRoutes.newsletter),
                      ),
```
with:
```dart
                      const SiteTopBar(),
```

In `lib/features/blog_detail/presentation/views/blog_post_detail_page.dart`, replace:
```dart
        BlogTopNavigationBar(
          onOpenHome: () => context.go(AppRoutes.home),
          onOpenBlogList: () => context.go(AppRoutes.blog),
        ),
```
with:
```dart
        const SiteTopBar(),
```

In `lib/features/newsletter/presentation/views/newsletter_page.dart`, replace:
```dart
                    BlogTopNavigationBar(
                      onOpenHome: () => context.go(AppRoutes.home),
                      onOpenBlogList: () => context.go(AppRoutes.blog),
                    ),
```
with:
```dart
                    const SiteTopBar(),
```

In all three files, replace `import 'package:my_portfolio/core/presentation/widgets/blog_top_navigation_bar.dart';` with `import 'package:my_portfolio/app/navigation/site_top_bar.dart';`.

- [ ] **Step 5: Run the analyzer and remove now-unused imports**

Run: `.fvm/flutter_sdk/bin/flutter analyze`
If it reports `unused_import` for `go_router` or `app_routes.dart` in any of the three blog files, delete exactly those import lines and re-run until `No issues found!`.

- [ ] **Step 6: Run the tests**

Run: `.fvm/flutter_sdk/bin/flutter test`
Expected: `All tests passed!` (all 4 router tests included).

- [ ] **Step 7: Commit**

```bash
git add lib/app/router/app_router.dart lib/features/blog_list lib/features/blog_detail lib/features/newsletter test/app/router
git commit -m "feat(router): landing, /work, /about and /contact routes; blog pages use the site top bar

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: Remove the long-scroll home, game, 3D Dash and skills orbit

**Files:**
- Delete:
  - `lib/features/game/`, `lib/features/skills/`, `lib/features/home/`.
  - `lib/features/projects/presentation/widgets/portfolio_desktop.dart`, `portfolio_mobile.dart` and `portfolio_section.dart`.
  - `lib/core/resources/asset_manager.dart`, `lib/core/presentation/widgets/blog_top_navigation_bar.dart` and `lib/core/presentation/widgets/animated_logo.dart`.
  - `assets/3d_models/`.
  - These images under `assets/images/`: `background.png`, `bird.png`, `ground.png`, `pipe_bottom.png`, `pipe_top.png`, `cream_curtain.png`, `light.png`, `mandala.png`, `meditating_man_low_res.jpeg`, `my_flutter_avatar.png`, `long_image.jpg`.
- Modify: `lib/app/di/service_locator.dart`, `pubspec.yaml`, `web/index.html`, `lib/core/resources/fa_icons.dart`

**Interfaces:**
- Consumes: nothing new. After this task, `HomeController`, `HomeMainPage`, `HomeSection` and `Footer` no longer exist; `SiteFooter` replaces `Footer`.

- [ ] **Step 1: Confirm nothing outside the deletion set uses these files**

Run:
```bash
grep -rln "features/game/\|features/skills/\|features/home/\|portfolio_desktop\|portfolio_mobile\|portfolio_section\|asset_manager\|blog_top_navigation_bar\|animated_logo" lib test \
  | grep -v "^lib/features/game/\|^lib/features/skills/\|^lib/features/home/\|^lib/features/projects/presentation/widgets/portfolio_\|^lib/core/resources/asset_manager.dart\|^lib/core/presentation/widgets/blog_top_navigation_bar.dart\|^lib/core/presentation/widgets/animated_logo.dart"
```
Expected: only `lib/app/di/service_locator.dart` (the `HomeController` import). If any other file appears, stop and report it.

- [ ] **Step 2: Delete the files**

```bash
git rm -rq lib/features/game lib/features/skills lib/features/home \
  lib/features/projects/presentation/widgets/portfolio_desktop.dart \
  lib/features/projects/presentation/widgets/portfolio_mobile.dart \
  lib/features/projects/presentation/widgets/portfolio_section.dart \
  lib/core/resources/asset_manager.dart \
  lib/core/presentation/widgets/blog_top_navigation_bar.dart \
  lib/core/presentation/widgets/animated_logo.dart \
  assets/3d_models \
  assets/images/background.png assets/images/bird.png assets/images/ground.png \
  assets/images/pipe_bottom.png assets/images/pipe_top.png \
  assets/images/cream_curtain.png assets/images/light.png assets/images/mandala.png \
  assets/images/meditating_man_low_res.jpeg assets/images/my_flutter_avatar.png \
  assets/images/long_image.jpg
ls assets/images
```
Expected: `ls` prints only `intro_video_thumb.jpg`.

- [ ] **Step 3: Remove `HomeController` from DI**

In `lib/app/di/service_locator.dart`, delete the line `import 'package:my_portfolio/features/home/presentation/controllers/home_controller.dart';` and delete this block:
```dart
    ..registerFactory(
      () => HomeController(
        launchService: getIt.get<AppLaunchService>(),
        projectsRepository: getIt.get<ProjectsRepository>(),
      ),
    )
```

- [ ] **Step 4: Drop the dependencies, the 3D asset and the model-viewer script**

In `pubspec.yaml`:
- Delete the dependency lines `  carousel_slider: ...`, `  flutter_3d_controller: ...` and `  flame: ...`.
- Delete the asset line `    - assets/3d_models/flutter_dash.glb`.

In `web/index.html`, delete the line:
```html
    <script type="module" src="/assets/packages/flutter_3d_controller/assets/model_viewer.min.js" defer></script>
```

- [ ] **Step 5: Trim `lib/core/resources/fa_icons.dart` to the icons still used**

Only `github`, `linkedin`, `instagram` (contact) and `flutter` (footer) remain in use. Delete the `android`, `apple`, `js`, `python`, `nodeJs`, `stripe`, `googlePay`, `applePay`, `globe`, `server` and `fire` constants, and the now-unused `_solid` constant. Keep the file's header comment.

- [ ] **Step 6: Resolve, analyze and test**

```bash
.fvm/flutter_sdk/bin/flutter pub get && .fvm/flutter_sdk/bin/flutter analyze && .fvm/flutter_sdk/bin/flutter test
```
Expected: `No issues found!` and `All tests passed!`. Fix any leftover unused import the analyzer names, then re-run.

- [ ] **Step 7: Verify nothing references the removed pieces**

```bash
grep -rn "flame\|flutter_3d_controller\|carousel_slider\|model_viewer\|HomeMainPage\|HomeController\|GamePreview\|Dash3D\|SkillsSection" lib test web pubspec.yaml
```
Expected: no output.

- [ ] **Step 8: Commit**

```bash
git add -A lib test assets pubspec.yaml pubspec.lock web/index.html
git commit -m "chore: remove long-scroll home, Flappy Bird, 3D Dash, skills orbit and unused assets

Drops flame, flutter_3d_controller and carousel_slider.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Verify on every width, measure, and open the PR

**Files:** none changed unless a check fails.

- [ ] **Step 1: Full checks and release build**

```bash
.fvm/flutter_sdk/bin/flutter analyze && .fvm/flutter_sdk/bin/flutter test && .fvm/flutter_sdk/bin/flutter build web --release
ls -l build/web/main.dart.js | awk '{print $5}'
du -sk build/web/assets
```
Expected: clean analyze, all tests pass, and the build succeeds. Record both sizes. The phase's baseline before this work was `main.dart.js` = 3,603,170 bytes. `main.dart.js` must be smaller, and `build/web/assets` should be smaller too, since the 2.3 MB 3D model is gone.

- [ ] **Step 2: Visual check at every width in light and dark**

Serve the build (`python3 -m http.server 8765 --directory build/web`, or the browser pane's preview) and check `/`, `/work`, `/about`, `/contact`, `/blog` and `/newsletter` at 375×812, 390×844, 768×1024 and 1440×900, each in light and dark. For each, confirm:
- no clipped text and no horizontal scroll;
- the top bar collapses to the menu below 1000 px;
- the contact panel is a right panel on desktop and a bottom sheet on mobile;
- the About video shows a thumbnail, and pressing play starts it.

Screenshot the landing and `/about` at 390 and 1440 for the PR description.

- [ ] **Step 3: Push and open the PR into `development`**

```bash
git push -u origin feat/landing_hub
gh pr create --base development --head feat/landing_hub --title "Landing hub phase 1: routes, top bar, contact panel, about page, cleanup" --body "$(cat <<'EOF'
## Summary

Phase 1 of `docs/superpowers/specs/2026-09-29-landing-hub-redesign-design.md`.

- Routes: `/` (temporary type-only landing), `/work` (interim project cards), `/about` (lazy intro video, bio, skills, experience, résumé), `/contact` (panel over the landing).
- Shared site chrome in `lib/app/navigation/`: top bar (menu sheet below 1000 px), text links, page scaffold, footer. Blog and newsletter pages use the new top bar.
- Contact form opens as a right panel on desktop and a bottom sheet on mobile, from any page.
- Bundled Archivo Extra Condensed, Archivo Condensed and IBM Plex Mono.
- Removed the long-scroll home, Flappy Bird (`flame`), the 3D Dash (`flutter_3d_controller`, 2.3 MB model, `model-viewer` script), the skills orbit, `carousel_slider` and unused images.

## Sizes

- `main.dart.js`: 3,603,170 bytes before, <after> bytes after (fill in from Task 9, Step 1).

## Before merge

- [ ] Aabhash reviews and edits the About bio in `lib/features/about/data/about_content.dart`.

## Test plan

- [x] `flutter analyze` clean
- [x] `flutter test` passes (new tests for palette, contact panel, top bar, about, work, landing and router)
- [x] Release build succeeds
- [x] Checked 375, 390, 768 and 1440 widths in light and dark

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```
Before running it, replace `<after>` in the body with the measured number from Step 1.
