<div align="center">

# Aabhash Rai — Portfolio

**My personal site, built in Flutter Web.**

[![Flutter](https://img.shields.io/badge/Flutter-3.35-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-backed-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Live](https://img.shields.io/badge/live-aabhashrai.com-1f6feb)](https://aabhashrai.com)

[**Visit the live site →**](https://aabhashrai.com)

</div>

---

## What's inside

A Flutter Web app with a home page, projects, skills, contact form, a Markdown-driven
blog, a newsletter signup, and a tiny game tucked away for fun. Backend is Firebase
(Firestore + Analytics + App Check). Deploys automatically to Hostinger on every PR
merged to `main`.

## Stack

Flutter · Dart · `go_router` · `get_it` · `dartz` · Firebase · `flame` · `flutter_markdown_plus`

## Architecture in a nutshell

Feature-first Clean Architecture — each feature owns its own `data / domain /
presentation` slice. Domain is pure Dart, repositories return `Either<Failure, T>`,
and UI state is driven by a small custom `Command<T>` primitive over `ChangeNotifier`
(no global state framework needed).

## Folder structure

```
lib/
├── app/             # Composition root: routing, DI, root widget
├── core/            # Shared primitives: Command<T>, errors, theme, services
├── constants/       # Colors, sizes, breakpoints
└── features/
    ├── home/
    ├── blog_list/
    ├── blog_detail/
    ├── projects/
    ├── skills/
    ├── contact/
    ├── newsletter/
    └── game/
        ├── data/         # datasources, models, repositories
        ├── domain/       # entities, repository contracts, usecases
        └── presentation/ # controllers, views, widgets
```

## Run it locally

```bash
flutter pub get
flutter run -d chrome
```


## Contributing — blog contributions are *very* welcome 🎉

If you've ever wanted to contribute to an open-source Flutter project, **the blog is
the perfect place to start.** I'd genuinely love your help here — whether it's a
typo fix, a new post, better Markdown rendering, nicer typography, dark-mode polish,
accessibility, code-block themes… all of it.

The blog code lives under:

- `lib/features/blog_list/` — the blog index
- `lib/features/blog_detail/` — the post view + Markdown rendering

**How to jump in:**

1. Open an issue (or just a draft PR) — even half-formed ideas are great.
2. Don't stress about matching the style perfectly. We'll iterate together in the PR.
3. First-time Flutter contributors especially welcome — happy to walk through the
   code with you.

For non-blog parts of the site, please open an issue first so we can chat before you
put real time in.

## License

Personal portfolio. Read it, learn from it, borrow patterns — just please don't
redeploy it as-is under your own name.

---

<div align="center">

Built by [Aabhash Rai](https://aabhashrai.com)

</div>
