# Landing Hub Redesign

Date: 2026-09-29
Status: Draft for review

## Goal

Turn aabhashrai.com from one long scrolling page into a landing page that works as a hub, with separate pages for Work, About and Writing, plus a Contact panel. The site should win freelance projects and a full-time mobile role, feel crafted rather than AI-generated, and use Flutter's strengths (real widgets, motion, instant in-app navigation) instead of fighting them.

## Why

- The long page stacked the most expensive things Flutter web can render on one scroll surface: two platform views (the YouTube iframe and the 3D Dash `model-viewer`), live `BackdropFilter` blur on frosted cards and the section rail, and a Flame game loop. That caused the scroll jank.
- A hub isolates heavy content per route. Tickers on hidden routes pause automatically, and the video only exists on the page that shows it.
- Routes in Flutter web are in-app navigation inside the already downloaded bundle, so moving between pages is instant and does not reload the site.
- A portfolio built in Flutter invites the question "why Flutter?". The landing answers it by running live widgets that visitors can touch.

## Constraints

- Position Aabhash as a mobile app developer, never as a "Flutter developer". Flutter can appear as a stack detail.
- The design must not look AI-generated: no eyebrow kickers, availability pills, stat rows, gradient blobs, glass cards or generic value-prop copy.
- Employer apps are never the landing page's focus.
- Every page must work on mobile. It is verified at 375×812, 390×844, 768 and 1440 widths.
- Keep the current light and dark palettes in `lib/core/resources/styles/home_palette.dart`.
- Flutter-native motion only. No Rive in this project.
- Every animation does one of three jobs: navigate, prove, or respond. Anything else is cut.

## Site structure

| URL | Page | Source |
|---|---|---|
| `/` | Landing hub | New; replaces `HomeMainPage` |
| `/work` | Work | Flagship projects (see "Work page") |
| `/about` | About | Video, bio, skills, experience, résumé |
| `/blog`, `/blog/:slug` | Writing | Existing; newsletter signup already after the article body |
| `/contact` | Landing with the contact panel open | Existing contact form |
| `/newsletter` | Newsletter | Existing, unchanged |
| `/content` | Redirect to `/` | Existing, unchanged |

Navigation:

- On the landing, the four phone widgets are the primary way in. A text-link row under the tagline (`WORK · ABOUT · WRITING · CONTACT · RÉSUMÉ`) serves skimmers, keyboard users and screen readers.
- Inner pages get a slim top bar. At 1000 px and wider: name (links home), the four links, theme toggle and résumé. Below 1000 px: name, theme toggle and a menu button that opens the links in a bottom sheet.
- Contact is a panel over the current page, reachable from every page. `/contact` opens it on top of the landing so it can be shared.
- Browser back and the iOS edge swipe pop the route with the reverse transition.

## Landing page

### Layout

Desktop (width ≥ 1000):

1. `SYDNEY, AUSTRALIA · raiaabhash3@gmail.com` in small mono caps. The email is a `mailto:` link.
2. `AABHASH RAI`, the dominant element.
3. One large phone, tilted slightly. Its screen is a home screen with four live widgets in a 2×2 grid: Work, About, Writing, Contact.
4. `I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS` in two lines.
5. Caption `live flutter widgets, not video. drag one.` followed by the text-link row.

The theme toggle sits in the top-right corner on every width.

Mobile and tablet (width < 1000): no phone mockup. The same four widgets fill the screen as a 2×2 grid, under the name and tagline. The caption drops "drag one." because there is no drag on touch. At 375×812 the whole landing fits without scrolling.

The same widget-grid component is used in both layouts, framed by the phone on desktop and full-bleed on mobile.

### Typography

- Name: Archivo Extra Condensed Black. Tagline: a less condensed Archivo cut, for readability at its smaller size.
- Small labels, caption and links: IBM Plex Mono Medium, uppercase, tracked.
- Font files are bundled as assets, not fetched from Google Fonts at runtime.

### Colour

- Light: background `#FFF1E6`, name `#5C4033`, tagline `#A67B5B` (a deeper tan than the palette's #B08968, which only reaches 2.86:1; this meets 3:1 for large text), labels `#6B4F3A`, links `#5C4033` with `#E6A4A4` hover and focus.
- Dark: background `#1A1410`, name `#F2E4D1`, tagline `#D4B896`, labels `#B8A896`.
- Widget screens are the only strong colour on the page. They use colours from the palette family: dusty pink `#E6A4A4`, tan `#BFA181`, deep brown `#5C4033` and cream `#FFF1E6`.
- New colour values become `HomePalette` fields, not hard-coded literals.

### The four live widgets

Each widget is a real Flutter widget with its own looping `AnimationController`, wrapped in a `RepaintBoundary`.

| Widget | Preview loop | Opens |
|---|---|---|
| Work | An app screen assembling itself from wireframe blocks to finished UI, about 5 s | `/work` |
| About | A still from the intro video (bundled asset) with a slow zoom and a play glyph, about 6 s | `/about` |
| Writing | An article card whose text lines write themselves, about 4 s | `/blog` |
| Contact | A chat bubble typing "Hi Aabhash, we're building…", then the typing dots, about 4 s | Embedded contact form inside the desktop phone (deferred); panel fallback elsewhere |

The Work preview is an invented screen and never shows employer apps.

### Motion

- Load: name and tagline words spring up from their baseline (vertical scale 0 to 1 plus an 8 px rise, 800 ms, overshoot to about 1.14, 100 ms stagger). The phone, or the mobile widgets, then scale in from 0 with the same spring, 1000 ms, starting 400 ms in, staggered 80 ms.
- Idle: the widget previews loop, and on desktop the phone floats ±4 px on a 6 s sine.
- Desktop hover: the phone lifts, its tilt eases to 0°, and the hovered widget shows `OPEN →`.
- Desktop drag and fling: the phone follows the pointer, tilts in proportion to drag velocity (clamped to ±8°), and on release springs back to rest with a `SpringSimulation`. A press without movement counts as a tap on the widget under the pointer.
- Mobile: tap opens the page. There is no drag physics, so nothing competes with page scroll.
- Reduced motion (`MediaQuery.disableAnimations`): no entrance, float or loops. Each preview shows its final frame.
- Not included: shaders, parallax, cursor trails.

## Opening pages

- Tapping a widget pushes its route with the widget's global rect as the transition origin. The page grows from that rect to full screen while the corner radius goes from the widget's radius to 0. The widget's content cross-fades into the page header. About 450 ms, with `Curves.easeInOutCubicEmphasized`.
- Pop reverses to the origin rect when it is known.
- With no origin (deep link, refresh, text link, top bar), the page fades in with a 12 px rise instead.
- Contact panel: on desktop it slides in from the right, 420 px wide; on mobile it is a bottom sheet. The page behind is dimmed. Esc, a tap outside, or the close button dismisses it. The form stays usable with the mobile keyboard open.

## Inner pages

### Work

- Flagship projects: Babe, Get This (personal native Android app) and Sadaqa.
- Project data stays hard-coded in Dart with bundled image assets, extending the existing `staticProjectSummaries` and `ProjectsRepository`. It changes a few times a year, and a commit already publishes through CI. Firestore plus Storage would add image CORS setup, loading and error states, and console-only editing for no benefit at this volume. The repository interface keeps a later move cheap.
- The detailed layout, copy and assets for both flagships are settled in a content session with Aabhash at the start of the Work phase. What happens to the remaining office projects is decided in that session too.
- Until then, `/work` shows the current project cards.

### About

In this order:

1. Intro video: a thumbnail with a play button. The YouTube player is created only when play is pressed. The thumbnail is a bundled asset, because CanvasKit cannot draw cross-origin YouTube images without CORS headers. The same asset feeds the About widget.
2. A short bio, drafted from the résumé and edited by Aabhash before merge.
3. Skills as a plain grouped list from the résumé: Android/native, cross-platform/iOS, architecture/testing/delivery, backend/payments.
4. Experience list: company, role and dates from the résumé.
5. Résumé download (`/resume.pdf`).

This replaces the skills orbit, the 3D Dash and the old skills section.

### Writing

The existing blog list and post pages, restyled only as far as the new top bar and fonts require. The newsletter signup already sits after the article body and stays there.

## Removed

- The long-scroll home page: `HomeMainPage` section keys and scroll-to-section code, the 01–05 section rail, `FrostedGlassContainer`, `Description`, `MainDesktop`, `MainMobile` and `GetInTouchButton`.
- The Flappy Bird feature (`lib/features/game`), its image assets and the `flame` dependency.
- The skills orbit, the 3D Dash, the `flutter_3d_controller` dependency, `assets/3d_models/flutter_dash.glb`, and the `model-viewer` script tag in `web/index.html`.
- The unused bounce-man animation widgets and the images only they use.
- `carousel_slider`, once nothing uses it.

Each removal is verified with a usage search before deletion.

## Error handling

- Tapping a widget before its page is ready shows a thin progress line, never a blank screen.
- If the video fails to load, the thumbnail stays with a "Watch on YouTube" link.
- Contact form errors keep the existing behaviour.

## Accessibility

- Name, tagline and links are real text.
- Each widget is a button with a semantic label such as "Open Work", with a visible focus ring. Enter and Space activate it.
- Tap targets are at least 48 px.
- Contrast meets WCAG AA for body text and 3:1 for large display text.

## Performance

- No `BackdropFilter` or platform views on the landing.
- Every animated widget sits in its own `RepaintBoundary`.
- Landing tickers pause when another route covers it.
- On desktop, no landing frame exceeds 16 ms at idle or during drag (checked with a Chrome performance trace).
- The first download must not grow overall: bundled fonts are offset by removing Flame, the 3D model and `model-viewer`.

## Testing and verification

- Widget tests:
  - The landing renders name, tagline, the four widgets and the text links.
  - It switches to the grid layout below 1000 px.
  - It builds with reduced motion on.
  - Activating each widget navigates to its route.
  - `/contact` opens the panel.
  - About and Work render their key content.
- Existing tests keep passing.
- Each phase:
  - `flutter analyze` is clean.
  - `flutter test` passes.
  - A release build succeeds.
  - Browser screenshots cover 375, 390, 768 and 1440 widths, in light and dark.

## Phases

Each phase is a PR into `development`, and the site stays usable after each one.

1. **Structure and cleanup.**
   - Routes (`/work`, `/about`, `/contact`), the inner-page top bar and the contact panel (without its final animation).
   - About built from existing content.
   - `/work` shows the current cards.
   - Bundled fonts and the new typography.
   - All removals.
   - A temporary landing with name, tagline and text links.
2. **Landing.**
   - The phone frame and the widget grid, with the four live previews.
   - The mobile layout.
   - Load-in motion, float, hover, drag and fling, and reduced motion.
3. **Transitions.**
   - The widget-to-page expand and collapse, the fallback fade, and the contact panel animation.
   - Back and swipe behaviour.
4. **Contact inside the phone.**
   - [x] Activating the Contact widget on desktop replaces the phone's 2×2 widget grid with the usable contact form inside the phone screen instead of opening the global panel.
   - [x] Add an obvious close/back action that restores the widget grid without losing the landing page.
   - [x] Make the embedded form scroll and resize safely inside the phone, including when the software keyboard is open.
   - [x] Keep the existing contact panel as the fallback for mobile, text-link navigation, inner pages and the shareable `/contact` route unless a later design decision replaces those entry points.
5. **Work content.**
   - The content session for Babe, Get This and Sadaqa (Aabhash provides assets), then the flagship layout.

## Out of scope

- Loading ahead while the visitor is on the landing (preloading images, prefetching blog data, deferred code loading). This gets its own architecture decision before any implementation.
- Rive animations and shaders.
- Moving the EmailJS private key to a Cloud Function (tracked separately).
- Removing the contact form's phone field.
- A blog redesign beyond the top bar and fonts.
