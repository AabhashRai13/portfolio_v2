# Decision: Replace Office Project Gallery With Personal Shipped Work

Date: 2026-04-27

## Decision

Replace the current portfolio grid of office/client projects with a personal-project-focused section.

The new section should highlight projects that are fully owned, built, shipped, and maintainable by me. The strongest first version should feature one flagship personal project that has been released publicly, ideally on the Play Store, instead of showing many professional projects from office work.

## What To Replace

Replace the current project-card gallery in:

`lib/features/projects/presentation/widgets/portfolio_desktop.dart`

and the matching mobile carousel in:

`lib/features/projects/presentation/widgets/portfolio_mobile.dart`

Current model:

- Many project cards.
- Mostly office/client apps.
- Equal visual weight for every project.
- Dependence on app posters and screenshots that may not be high quality.
- Project ownership is not immediately clear.

New model:

- One flagship personal project as the main proof point.
- Clear shipped status, such as `Built and shipped on Play Store`.
- A short case-study style story: problem, what I built, technical choices, and result.
- Direct CTA to Play Store or live product.
- Optional secondary CTA to a deeper case study, GitHub repo, or technical write-up.
- Office/client work removed from the main portfolio section.

## Why

The current section is the weakest part of the portfolio because it reads like a broad app gallery rather than strong proof of engineering ownership.

From a recruiter, senior developer, or head-of-engineering perspective, a personal shipped project is a stronger signal because it proves:

- I can take an idea from zero to release.
- I can make product and engineering decisions without depending on office context.
- I can explain the whole system, tradeoffs, architecture, release process, and maintenance story.
- I am not relying on work that a company or client may later ask me to remove.
- The section is honest and fully under my control.

Showing fewer projects with deeper ownership is better than showing many projects that viewers will not inspect closely. A recruiter is more likely to remember one strong shipped product than eight cards with unclear contribution details.

## Placement

Keep the section in the same main-page position for now: after Skills and the intro video, before Contact.

Current page flow:

1. Hero
2. Skills
3. Intro video
4. Portfolio
5. Contact

Recommended page flow after the change:

1. Hero
2. Skills
3. Intro video
4. Featured personal project
5. Contact

This placement works because Skills establishes capability first, the intro video gives personality and context, and the featured project then proves execution. Contact should remain after the proof section so the visitor reaches it after seeing the strongest evidence.

If the intro video feels less important than the shipped project later, test moving the featured personal project directly after Skills. For the first redesign, keep the placement stable and change the content/design first.

## Design Direction

The section should stop depending on poster quality.

Use a product-proof layout instead:

- Left side: product story, proof bullets, tech stack, and CTAs.
- Right side: phone mockup, clean screenshots, or app-store-style screenshot stack.
- Avoid a large grid.
- Avoid hover-only information.
- Use specific proof text instead of generic summaries.

Example structure:

```text
Featured project

[App Name]
Built and shipped by me on Play Store.

- Designed and developed the Flutter app end to end.
- Built authentication, persistence, analytics, and release flow.
- Maintained the app after launch based on real user feedback.

[View on Play Store] [Read case study]
```

## What Not To Do

- Do not keep office/client projects as the main portfolio proof.
- Do not rely on low-quality posters or screenshots.
- Do not show many equal-weight cards.
- Do not make the visitor click every card to understand the work.
- Do not make claims about office projects that cannot be clearly backed up.
