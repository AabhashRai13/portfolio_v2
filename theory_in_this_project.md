# Biamp Senior Flutter Interview Prep

Built from a scan of your actual repo (`my_portfolio`). Every example below points at a real file you can re-read on the train. Anything weak is flagged so you can steer the conversation away from it.

---

## Table of Contents

- [Part 1 — Project at a Glance](#part-1--project-at-a-glance)
- [Part 2 — OOP Principles in Your Code](#part-2--oop-principles-in-your-code)
- [Part 3 — SOLID in Your Code](#part-3--solid-in-your-code)
- [Part 4 — Design Patterns in Your Code](#part-4--design-patterns-in-your-code)
- [Part 5 — Flutter-Specific](#part-5--flutter-specific)
- [Part 6 — Top 5 STAR Stories](#part-6--top-5-star-stories)
- [Part 7 — Gaps & Things Not to Bring Up](#part-7--gaps--things-not-to-bring-up)
- [Part 8 — Mock Interview Questions](#part-8--mock-interview-questions)
- [Part 9 — One-line Cheat Sheet](#part-9--one-line-cheat-sheet)

---

## Part 1 — Project at a Glance

### Architecture
**Theory:** Architecture is the high-level structure that separates responsibilities so code stays understandable, testable, and change-friendly.

**Feature-first Clean Architecture** with three explicit layers per feature. The split is enforced as a project convention (`CLAUDE.md`):

```
features/<feature>/
  data/        # datasources, models (DTOs), repositories impl, feature services
  domain/      # entities, abstract repositories, use cases, domain utils
  presentation/  # controllers, views, widgets, styles
```

Rules you can quote in the interview:
- Domain is **pure Dart** — zero Flutter imports, zero data-layer imports.
- Data implements domain contracts and maps external shapes (Firestore docs, EmailJS payloads) to domain entities.
- Presentation depends on use cases or repositories — never on Firestore directly.

### State management
**Theory:** State management is how the app stores, updates, and reacts to UI data over time.

**Custom `Command<T>` pattern** (`lib/core/commands/command.dart`) wrapping `ChangeNotifier`. Views subscribe with `ListenableBuilder`. No Bloc, no Riverpod, no Provider — just `ChangeNotifier` + `get_it`. (`flutter_bloc` is in `pubspec.yaml` but not actually used — see Part 7.)

The interview-ready framing: *"It's the Command + Observer pattern. Each async action gets a Command object that exposes `isLoading / data / error`. The view binds to it with `ListenableBuilder`. I picked it over Bloc because the app is small and predictable, and Command keeps the boilerplate per feature to one class."*

### Key dependencies (`pubspec.yaml`)
**Theory:** Dependencies are external packages the project uses instead of building every capability from scratch.

- `get_it` — service locator / DI
- `go_router` — declarative routing
- `dartz` — `Either<Failure, T>` for railway-style error handling
- `cloud_firestore`, `firebase_analytics`, `firebase_app_check`, `firebase_core`
- `flame` — game loop for the Flappy Bird side feature
- `flutter_markdown_plus`, `markdown` — blog rendering
- `emailjs` — contact form transport
- `universal_html` — browser localStorage on web
- `equatable` — value equality (used on `Failure`)
- `mockito` — generated mocks for tests
- `very_good_analysis` — strict lint set

---

## Part 2 — OOP Principles in Your Code

### 1. Encapsulation ⭐
**Theory:** Encapsulation hides internal data and implementation details behind a small public API.

**Example:** `BlogEngagementLocalStore` hides every detail of "is this browser's like/view tracked".
`lib/features/blog_detail/data/services/blog_engagement_local_store.dart`

```dart
class BlogEngagementLocalStore {
  static const String _browserIdKey = 'blog.browserId';
  static const String _sessionIdKey = 'blog.sessionId';

  bool hasLiked(String slug) =>
      html.window.localStorage[_likedKey(slug)] == 'true';

  void markLiked(String slug) {
    html.window.localStorage[_likedKey(slug)] = 'true';
  }

  String _likedKey(String slug) => 'blog.liked.$slug';
}
```

**Interview language:** *"The repository never touches `window.localStorage` directly. It asks the store `hasLiked(slug)` / `markLiked(slug)`. The storage keys, the ID generation, the localStorage vs sessionStorage choice — all of that is encapsulated. If I move to IndexedDB tomorrow, only this class changes."*

### 2. Inheritance — used appropriately ⭐
**Theory:** Inheritance lets one class reuse and specialize another class when it truly represents an IS-A relationship.

**Example:** A sealed-ish `Failure` hierarchy that subclasses inherit only data + equality from.
`lib/core/error/failures.dart:3-83`

```dart
abstract class Failure extends Equatable implements Exception {
  const Failure({this.message, this.statusCode, this.userId, this.context});
  ...
}

class ServerFailure   extends Failure { const ServerFailure({...}) : super(...); }
class NetworkFailure  extends Failure { ... }
class PermissionFailure extends Failure { ... }
class NotFoundFailure extends Failure { ... }
class TimeoutFailure  extends Failure { ... }
class UnexpectedFailure extends Failure { ... }
```

Also `Command<T> extends ChangeNotifier` (`lib/core/commands/command.dart:3`) inherits the listener mechanism rather than reinventing it. And in the Flappy game: `class Bird extends SpriteComponent with CollisionCallbacks` (`lib/features/game/presentation/components/bird.dart:8`) — inheritance + mixins from Flame.

**Interview language:** *"I use inheritance sparingly — only when the subclass really IS-A the base. For errors I wanted typed branches so the `mapFailureToMessage` translator could dispatch on type. Anywhere I'd be tempted to inherit to share unrelated behavior, I prefer composition — controllers compose use cases and services, they don't inherit from them."*

### 3. Polymorphism ⭐
**Theory:** Polymorphism lets different classes be used through the same contract while each provides its own behavior.

**Example:** Repository interfaces with multiple implementations swapped via DI.
- `NewsletterRepository` (`lib/features/newsletter/domain/repositories/newsletter_repository.dart`) → today `StubNewsletterRepository`, tomorrow `ButtondownNewsletterRepository`.
- `BlogListRepository` → `FirestoreBlogListRepositoryImpl`, but tests inject a `MockBlogListRepository`.
- `AppLaunchService` → `UrlLauncherAppLaunchService` in prod, `_FakeLaunchService` in tests.

```dart
// lib/features/newsletter/presentation/controllers/newsletter_controller.dart:7-11
class NewsletterController {
  NewsletterController({required NewsletterRepository newsletterRepository})
      : _newsletterRepository = newsletterRepository;
  final NewsletterRepository _newsletterRepository;
}
```

Also `mapFailureToMessage` (`lib/core/error/failure_message_mapper.dart`) dispatches polymorphically on `Failure` subtype using `is` checks.

**Interview language:** *"The controller doesn't know whether it's talking to Buttondown, a Firestore stub, or a fake in a test. It only knows the `NewsletterRepository` contract. That's polymorphism doing real work — it's why I can swap the data source without touching the view."*

### 4. Abstraction ⭐
**Theory:** Abstraction exposes what something can do while hiding how it does it.

**Example:** Domain layer defines contracts; data layer implements them.
`lib/features/blog_detail/domain/repositories/blog_detail_repository.dart`

```dart
abstract class BlogDetailRepository {
  ResultFuture<BlogPostEntity> getBlogPostBySlug(String slug);
  ResultFuture<bool> recordPostRead(BlogPostEntity post);
  ResultFuture<bool> likePost(BlogPostEntity post);
  ResultFuture<List<BlogCommentEntity>> getComments(String postId);
  ResultVoid addComment({required String postId, required String authorName, required String message});
}
```

The implementation orchestrates a Firestore data source, a local engagement store, and an analytics service (`lib/features/blog_detail/data/repositories/firestore_blog_detail_repository.dart`). The controller never sees any of that.

**Interview language:** *"The domain layer states what the feature can do. The data layer decides how. That abstraction boundary is the thing that lets me onboard a new dev in an afternoon — they don't have to understand Firestore to ship a feature."*

---

## Part 3 — SOLID in Your Code

### 5. Single Responsibility ⭐⭐
**Theory:** Single Responsibility means a class should have one main reason to change.

The blog detail feature is your strongest example. One feature, five collaborators, each with one job:

| Class | File | Job |
|---|---|---|
| `BlogDetailRemoteDataSource` | `data/datasources/` | Talk to Firestore. |
| `BlogPostDocument` | `data/models/` | Map Firestore JSON ↔ `BlogPostEntity`. |
| `BlogEngagementLocalStore` | `data/services/` | Browser storage for likes/views. |
| `BlogAnalyticsService` | `data/services/` | Fire Firebase Analytics events safely. |
| `FirestoreBlogDetailRepositoryImpl` | `data/repositories/` | Orchestrate the four above behind the domain contract. |
| `GetBlogPostUseCase` | `domain/usecases/` | Parse markdown into headings + sections after fetch. |
| `BlogPostDetailController` | `presentation/controllers/` | Hold UI state via Commands; expose actions. |
| `ReadingProgressViewModel` | `presentation/controllers/` | One job: scroll position → `[0,1]`. |
| `TocViewModel` | `presentation/controllers/` | One job: which heading is active. |

**Interview language:** *"On the blog detail page, the reading-progress bar and the table-of-contents both need to react to scroll. I could have shoved both into one controller, but their reasons to change are different. The progress bar's contract is 'give me a number from 0 to 1' — the TOC's is 'tell me which heading is active'. Different concerns, different ViewModels."*

### 6. Open/Closed ⭐
**Theory:** Open/Closed means code should be open for extension but closed for modification.

**Example you can absolutely tell as a story:** `StubNewsletterRepository`.
`lib/features/newsletter/data/repositories/stub_newsletter_repository.dart:7-9`

```dart
// Placeholder until the Buttondown API key is approved.
// Swap this for ButtondownNewsletterRepository in service_locator once ready.
class StubNewsletterRepository implements NewsletterRepository {
  @override
  ResultFuture<SubscriptionResult> subscribe(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const Right(SubscriptionResult.success);
  }
}
```

To go live with Buttondown: write a new `ButtondownNewsletterRepository`, change **one line** in `service_locator.dart`. Controller, view, tests — untouched.

**Interview language:** *"The feature is open for extension — I can add a real Buttondown impl — but the consumers are closed for modification. That's exactly the kind of code I want when a business decision changes mid-sprint."*

### 7. Liskov Substitution ⭐
**Theory:** Liskov Substitution means a subtype should be usable anywhere its parent or interface is expected without breaking behavior.

Any `Failure` subtype substitutes for `Failure` without breaking `mapFailureToMessage` or `FirestoreRequestHandler.run`. Any `NewsletterRepository` substitutes for the interface — tests substitute a `_FakeNewsletterRepository` and the controller behaves identically.

**Interview language:** *"All my repository implementations honor the same contract, including the failure modes. A fake repo can return `Left(NetworkFailure())` and the controller code path is the same as production. That's why my controller tests don't need Firestore."*

### 8. Interface Segregation ⚠️ (be cautious here)
**Theory:** Interface Segregation means clients should depend only on the methods they actually use.

Most of your repos are intentionally narrow:
- `BlogListRepository` — 1 method (with `// ignore: one_member_abstracts`).
- `NewsletterRepository` — 1 method.
- `ContactRepository` — 1 method.
- `ProjectsRepository` — 1 method.
- `AppLaunchService` — 1 method.

`BlogDetailRepository` has 5 methods — read post, record read, like, get comments, add comment. They all serve the detail page so they're cohesive, but a strict ISP reading would say "split reads from writes" (CQRS-ish).

**Interview language:** *"I keep contracts narrow by default — most of my repos have a single method, and I suppress the `one_member_abstracts` lint deliberately. On the blog detail repo I bundled five methods because they all belong to a single client — the detail page. If I had a second client that only needed reads, I'd split it then, not before."*

⚠️ **Don't volunteer:** that you could critique your own `BlogDetailRepository` — they may push and ask why you didn't split it. Have the "single client" defense ready.

### 9. Dependency Inversion ⭐⭐
**Theory:** Dependency Inversion means high-level code depends on abstractions, while low-level details implement those abstractions.

This is the principle your code best illustrates. Look at the controller constructor pattern — **every single controller depends on abstractions only:**

```dart
// lib/features/blog_list/presentation/controllers/blog_list_controller.dart:6-11
class BlogListController {
  BlogListController({required GetBlogPostsUseCase getBlogPosts})
      : _getBlogPosts = getBlogPosts;
  final GetBlogPostsUseCase _getBlogPosts;
}
```

The use case depends on the abstract `BlogListRepository`, not on `FirestoreBlogListRepositoryImpl`. The composition root that wires concretes to abstractions is `lib/app/di/service_locator.dart`.

**Interview language:** *"High-level code — controllers, use cases — depends on abstractions. Low-level code — Firestore, EmailJS, URL launcher — implements those abstractions. The wiring happens in one file: `service_locator.dart`. If I ever rip Firebase out and put a REST API behind it, I'm changing one file and zero controllers."*

---

## Part 4 — Design Patterns in Your Code

### 10. Repository Pattern ⭐⭐
**Theory:** The Repository Pattern hides data-source details behind a domain-friendly interface.

Textbook implementation across every feature. The domain layer owns the abstract contract; the data layer implements it; controllers consume via DI.

- Abstract: `lib/features/blog_list/domain/repositories/blog_list_repository.dart`
- Concrete: `lib/features/blog_list/data/repositories/firestore_blog_list_repository.dart`
- DTO ↔ entity adapter: `lib/features/blog_list/data/models/blog_post_summary_document.dart`

The repo also wraps every call in a `FirestoreRequestHandler.run<T>(...)` (`lib/core/services/firestore_request_handler.dart`) that turns `FirebaseException`, `TimeoutException`, `NotFoundException` into typed `Failure` subtypes — so the repo always returns `Either<Failure, T>`, never throws.

### 11. Factory pattern ⭐
**Theory:** The Factory Pattern centralizes object creation so callers do not need to know construction details.

Two distinct flavors used correctly:

**Dart factory constructors** for parsing external shapes:
`lib/features/blog_list/data/models/blog_post_summary_document.dart:16-36`

```dart
factory BlogPostSummaryDocument.fromFirestore(
  QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
) {
  final data = snapshot.data();
  ...
  return BlogPostSummaryDocument(...);
}
```

**Named-constructor "union" factories** for variant types:
`lib/features/home/presentation/models/home_navigation_target.dart`

```dart
class HomeNavigationTarget {
  const HomeNavigationTarget._({this.section, this.route, this.externalUrl});
  const HomeNavigationTarget.scroll(HomeSection section) : this._(section: section);
  const HomeNavigationTarget.route(String route)         : this._(route: route);
  const HomeNavigationTarget.external(String externalUrl): this._(externalUrl: externalUrl);
}
```

⚠️ Be ready for this critique: this is a hand-rolled tagged union; modern Dart would use a sealed class or `freezed`. Acknowledge if asked.

### 12. Singleton ⭐ (used appropriately)
**Theory:** Singleton means one shared instance is reused across the app when a dependency should be long-lived.

`get_it` is your service locator. **Crucially you distinguish:**

- `registerLazySingleton<T>` for stateful, long-lived collaborators: `FirestoreRequestHandler`, `BlogEngagementLocalStore`, `BlogAnalyticsService`, repositories, use cases.
- `registerFactory` for **controllers** — a new instance per route entry. (`lib/app/di/service_locator.dart:104-137`)

**Interview language:** *"Controllers are factories on purpose. If I made the contact controller a singleton, the form would remember stale text when you navigate away and come back. Singletons are for stateless or long-lived collaborators only."*

### 13. Observer pattern ⭐
**Theory:** The Observer Pattern lets listeners automatically react when an object changes.

`Command<T> extends ChangeNotifier` is the observer. Views subscribe via `ListenableBuilder`.
`lib/core/commands/command.dart`

```dart
class Command<T> extends ChangeNotifier {
  T data;
  bool isLoading;
  String? error;
  void execute() => notifyListeners();
}
```

Side effects (snackbars) listen explicitly in `initState` per the CLAUDE.md convention:
`lib/features/newsletter/presentation/widgets/newsletter_subscribe_widget.dart:24-35`

```dart
@override
void initState() {
  super.initState();
  _controller.subscribeCommand.addListener(_handleSubscribeFeedback);
}
```

### 14. Strategy pattern ⭐
**Theory:** The Strategy Pattern swaps behavior by selecting a different implementation or option behind the same usage point.

Three concrete spots:

1. **Sort strategy:** `BlogPostSortOrder` enum (`get_blog_posts_use_case.dart:5-12`) drives `sortPosts()`.
2. **Launcher strategy:** `AppLaunchService` interface, `UrlLauncherAppLaunchService` concrete (`lib/core/services/app_launch_service.dart`).
3. **Scroll-physics strategy:** `PortfolioScrollBehavior` (`lib/core/services/smooth_wheel_scroll_controller.dart:15-29`) overrides `getScrollPhysics` to swap in `ClampingScrollPhysics`.

### 15. Adapter pattern ⭐
**Theory:** The Adapter Pattern converts one shape or interface into another shape the app expects.

`BlogPostSummaryDocument` adapts Firestore's `QueryDocumentSnapshot` into the domain's `BlogPostSummaryEntity`. Same shape for `BlogPostDocument` and `BlogCommentDocument`. The entity stays Flutter-free; the document knows about `Timestamp`.

```dart
// blog_post_summary_document.dart:47-58
BlogPostSummaryEntity toEntity() {
  return BlogPostSummaryEntity(id: id, slug: slug, title: title, ...);
}
```

**Interview language:** *"Firestore gives me a `Timestamp`; my domain wants a `DateTime`. The document class is the adapter between those shapes. The domain entity has zero Firestore types in it — that's how I keep the domain layer testable in pure Dart."*

### 16. Dependency Injection ⭐⭐
**Theory:** Dependency Injection means passing dependencies from the outside instead of creating them inside the class.

**Constructor injection everywhere.** No `getIt.get<>()` calls inside controllers, use cases, or repositories — they receive their collaborators. The only place that calls `getIt` is the composition root (`service_locator.dart`) and the router (`app_router.dart`) which is the entry point for each screen.

```dart
// service_locator.dart:88-92
..registerLazySingleton<GetBlogPostsUseCase>(
  () => GetBlogPostsUseCase(repository: getIt.get<BlogListRepository>()),
)
```

**Interview language:** *"The whole codebase passes dependencies through constructors. The service locator is only consulted at the boundary — in `service_locator.dart` itself and in `app_router.dart` where I resolve a controller per route. That keeps everything else testable without mocking a global."*

---

## Part 5 — Flutter-Specific

### 17. Stateless vs Stateful — your choices ⭐
**Theory:** A stateless widget has no lifecycle-owned mutable state; a stateful widget owns state, listeners, controllers, or lifecycle work.

Stateless by default. Stateful only when there's a lifecycle reason:

- `PortfolioApp` (`lib/app/app.dart`) — stateless: just declares structure.
- `AppThemeScope` (`lib/core/presentation/widgets/app_theme_scope.dart`) — stateless: reads from `AppThemeController` via `ListenableBuilder`.
- `NewsletterSubscribeWidget` — **stateful** because it owns a listener on `subscribeCommand` that must be detached in `dispose`.
- `BlogPostDetailPage` — **stateful** because `initState` triggers `controller.loadPost(slug)` and registers a listener for snackbar feedback.

**Interview language:** *"My default is stateless. I only reach for stateful when I need `initState`/`dispose` — usually because a widget owns a listener or a controller's lifecycle. Side effects go in listeners registered in `initState`, never in `build` or `addPostFrameCallback` inside `build`."*

### 18. Widget composition ⭐
**Theory:** Widget composition builds complex UIs by combining small focused widgets instead of one large widget.

`BlogPostDetailPage` (`lib/features/blog_detail/presentation/views/blog_post_detail_page.dart`) is your headline example: it composes
`BlogTopNavigationBar`, `BlogPostHeader`, `BlogTocCollapsible` / `BlogTocSidebar`, `BlogPostMarkdownCard`, `BlogPostEngagementCard`, `BlogCommentFormCard`, `BlogCommentsList`, `ReadingProgressBar`, and the responsive `_buildLayout` switch.

Each is a small widget in `presentation/widgets/`. The page only orchestrates.

### 19. Async — Future, Stream, async/await ⭐
**Theory:** Async programming lets the app wait for slow work like network calls without freezing the UI.

Heavy use of `Future` + `async/await`. **Notable:** parallelism with `Future.wait`:
`lib/features/blog_detail/data/repositories/firestore_blog_detail_repository.dart:47-51`

```dart
final counts = await Future.wait<int>([
  _remoteDataSource.fetchLikeCount(postDocument.id),
  _remoteDataSource.fetchCommentCount(postDocument.id),
  _remoteDataSource.fetchViewCount(postDocument.id),
]);
```

⚠️ **You don't use Streams.** Firestore supports `.snapshots()` for live updates, but you use `.get()` everywhere. Be ready for *"would you use streams here?"* — see the answer in Part 8.

### 20. Error handling ⭐⭐ (probably your single strongest topic)
**Theory:** Error handling turns failures into predictable typed states instead of letting raw exceptions leak through the app.

A three-layer funnel that you can draw on a whiteboard:

1. **Data layer** — `FirestoreRequestHandler.run<T>` (`lib/core/services/firestore_request_handler.dart`) wraps every Firestore call in a `try/catch` and maps:
   - `FirebaseException(code: 'permission-denied')` → `PermissionFailure`
   - `FirebaseException(code: 'unavailable' | 'network-request-failed')` → `NetworkFailure`
   - `TimeoutException` → `TimeoutFailure`
   - `NotFoundException` (your own) → `NotFoundFailure`
   - else → `UnexpectedFailure`
2. **Domain return type** — `typedef ResultFuture<T> = Future<Either<Failure, T>>`. No exceptions cross the data/domain boundary.
3. **Presentation** — controller does `result.fold((failure) => setError(mapFailureToMessage(failure, fallbackMessage: ...)), (data) => setData(data))`. `mapFailureToMessage` (`lib/core/error/failure_message_mapper.dart`) gives the human-readable string.

**Interview language:** *"Exceptions are an implementation detail of the data layer. Nothing above the repository sees a raw exception — the domain returns `Either<Failure, T>`. That makes every error path testable: I just return `Left(NetworkFailure())` from a fake repo and assert what the controller does."*

### 21. Testing approach ⭐
**Theory:** Testing verifies behavior automatically so refactors and requirement changes do not silently break the app.

You have **3 layers** of tests:

| File | What it proves |
|---|---|
| `test/features/blog_detail/domain/utils/markdown_heading_parser_test.dart` | Pure-Dart unit test on a domain util. |
| `test/features/blog_detail/domain/usecases/get_blog_post_use_case_test.dart` | Use case with a Mockito-generated `MockBlogDetailRepository`. |
| `test/features/blog_detail/presentation/blog_post_detail_controller_test.dart` | Controller orchestration — verifies that `likePost` is a no-op when already liked, that view counts bump only on `recordPostRead=true`, etc. |
| `test/features/blog_detail/presentation/reading_progress_view_model_test.dart` | Widget test with `pumpWidget` proving the VM doesn't notify for sub-threshold scroll deltas — a real perf assertion. |
| `test/features/newsletter/presentation/newsletter_controller_test.dart` | Hand-rolled fake repo (no Mockito) — light, readable. |
| `test/features/contact/presentation/contact_controller_test.dart` | Same pattern. |

Mocks are centralized via `@GenerateNiceMocks` in `test/features/blog_detail/blog_detail_mocks.dart`.

**Interview language:** *"My controllers are unit-testable because their dependencies are abstractions injected at the constructor. I use Mockito where I need verification on method calls, hand-rolled fakes where I just need a stub. The reading-progress ViewModel even has a widget test that proves it suppresses sub-threshold notifications — that's a performance invariant I want regression coverage on."*

---

## Part 6 — Top 5 STAR Stories

These are written as *you talking*, not as definitions. Memorize the beats, not the exact words.

### Story 1 — Newsletter feature, Open/Closed in action ⭐

> **Situation:** I wanted to ship a newsletter subscribe form on my portfolio, but I was waiting on a Buttondown API key approval. I didn't want to block the UI work.
>
> **Task:** Build the feature end-to-end so the form is real, but make it trivial to swap in the real backend later.
>
> **Action:** I defined an abstract `NewsletterRepository` in the domain layer with a single `subscribe(email)` method returning `Either<Failure, SubscriptionResult>`. I wrote a `StubNewsletterRepository` that just delays 600ms and returns success. The controller, the view, the form validation, the snackbar feedback — all of that consumes the abstraction. When the key lands, I'll add `ButtondownNewsletterRepository` and change one line in the service locator.
>
> **Result:** I shipped the form today without faking it in the UI, and the cutover is a one-file change. Open/closed in action — the feature is open for extension but my controller and view are closed for modification.

### Story 2 — Centralizing Firestore error handling ⭐

> **Situation:** Early on, every Firestore call in my repositories had its own try/catch that turned exceptions into user-readable strings. Same `permission-denied` mapping in five places, slightly different wording in each.
>
> **Task:** Stop repeating myself and make sure no part of the app saw a raw `FirebaseException`.
>
> **Action:** I built a `FirestoreRequestHandler.run<T>` that takes the request lambda and an operation name. It wraps the call, applies a 12-second timeout, and maps Firebase error codes to typed `Failure` subclasses — `PermissionFailure`, `NetworkFailure`, `TimeoutFailure`, etc. Every repository now returns `Either<Failure, T>`. The presentation layer maps the typed failure to a user message through a single `mapFailureToMessage` translator.
>
> **Result:** Adding a new Firestore-backed feature is mechanical — wrap the call, return `ResultFuture<T>`, done. Every failure path is testable by injecting a fake repo that returns `Left(failure)`. And user-facing copy lives in one file, not scattered across catch blocks.

### Story 3 — Splitting the blog detail page into ViewModels ⭐

> **Situation:** The blog detail page has a reading-progress bar at the top and a sticky table of contents on desktop. Both react to scroll. Initially I had all of it inside the page's `State`.
>
> **Task:** The `build` method was getting tangled and untestable — too much imperative logic. I needed to separate concerns.
>
> **Action:** I pulled out two small `ChangeNotifier`-based ViewModels — `ReadingProgressViewModel` and `TocViewModel`. Each owns one scroll listener and exposes one piece of derived state: a `[0,1]` progress number, and an `activeIndex` integer. The widgets that render the bar and the TOC are now dumb — they bind via `ListenableBuilder`.
>
> **Result:** I got real widget tests on both — the progress VM even has a test asserting it doesn't notify for sub-pixel scroll deltas, which is a performance invariant I'd otherwise lose to a refactor. The page's `build` method is back to describing structure, no imperative logic.

### Story 4 — Choosing constructor DI over a global service locator ⭐

> **Situation:** I'm using `get_it` as the composition root. The lazy answer would be to call `getIt.get<Repository>()` from every controller.
>
> **Task:** Keep the service locator from leaking into the rest of the codebase — otherwise everything that uses it becomes hard to test in isolation.
>
> **Action:** Every controller, use case, and repository takes its dependencies through the constructor. The only places that call `getIt.get<>()` are `service_locator.dart` itself (the registration block) and `app_router.dart` (one call per route to resolve a controller). I register controllers as `factory` so each route entry gets a fresh instance — singletons would carry stale form text across navigations.
>
> **Result:** Every controller is testable without touching `get_it`. The contact controller test just passes a `_FakeContactRepository` directly. The composition root is the only file that knows about the wiring graph.

### Story 5 — Custom `Command<T>` instead of Bloc/Riverpod ⭐

> **Situation:** I started this portfolio knowing I'd want a clean state-management story but didn't want to pull in Bloc for what's mostly a content site.
>
> **Task:** Pick something with enough structure to scale, but light enough that it doesn't dominate the codebase.
>
> **Action:** I wrote a `Command<T> extends ChangeNotifier` — about 40 lines. Each async action gets a Command exposing `isLoading`, `data`, `error`. Controllers own Commands; views bind via `ListenableBuilder`. Side effects like snackbars register a listener in `initState`, never in `build`.
>
> **Result:** Pattern is consistent across every feature — newsletter, contact, blog list, blog detail. Three states are always represented, no implicit "is loading and has data" combinations. If the project grew enough to need Bloc, I could migrate one Command at a time without a big-bang rewrite — the Command boundary is the contract.

---

## Part 7 — Gaps & Things Not to Bring Up

### What you're NOT using that a senior Flutter dev typically would

| Gap | What to say if asked |
|---|---|
| **No Streams / no Firestore `.snapshots()`.** All your reads are one-shot `.get()`. | *"For a portfolio with infrequent writes the one-shot read is fine. If the comment count needed to update live as readers like a post, I'd swap the count fetch for a `.snapshots()` listener and expose it as a `Stream<int>` to the controller."* |
| **No code generation** beyond Mockito. No `freezed`, no `json_serializable`, no `riverpod_generator`. | *"`copyWith` and `Equatable` are manual today; on a larger team I'd add `freezed` to remove the boilerplate."* |
| **No value equality on entities.** Your own test even calls this out: `// BlogPostEntity has no value equality`. | *"Entities are deliberately reference-equality only — I haven't needed value comparisons in tests yet. If I did, I'd extend Equatable like Failure does."* |
| **No CI workflow committed** beyond what's in `.github/`. | Don't volunteer. If asked: *"Lint is `very_good_analysis`, tests run on push locally, GitHub Actions is on the roadmap."* |
| **Mixing Mockito and hand-rolled fakes.** | This is actually defensible: *"Mockito where I want call verification, fakes where I just want a stub. The fake is more readable when there's no verification to do."* |
| **Web-only `universal_html` localStorage.** Would break on mobile. | *"The portfolio is web-only by design — the storage layer would need an adapter for mobile. That's the kind of thing the repository pattern was built for."* |

### Weak spots — DO NOT volunteer these

⚠️ **`lib/keys.dart` imported directly by `EmailJsContactRepository`.** Secrets in source is a red flag at a senior interview. If they ask about secret management, redirect: *"Today they're build-time constants gitignored locally; for production I'd move to `--dart-define` with env-injected values at build."*

⚠️ **`flutter_bloc` and `mockito` in `dependencies` (not `dev_dependencies`).** `mockito` is a test-only dep and shouldn't be shipped; `flutter_bloc` isn't even used. If they're looking at your `pubspec.yaml` live, they will notice. Fix this before the interview if you have time — move `mockito` to `dev_dependencies` and remove `flutter_bloc`.

⚠️ **`Command.dispose()` is called manually by controllers, not via `super.dispose()` chaining patterns.** Works, but a Bloc/Riverpod reviewer would frown. Don't bring up the Command's lifecycle unless asked.

⚠️ **`BlogPostDetailController` has 4 separate Commands + form key + 2 TextEditingControllers + 4 validators.** It works, but it's the largest controller. If asked *"would you split it?"*, the answer is yes — comments could be their own controller.

⚠️ **`Bird.onCollision` casts the parent with `(parent! as FlappyGame)`.** Tight coupling. Don't bring up the Flame game architecture unless they ask.

### Questions where the interviewer might push you

1. **"Why didn't you use Bloc/Riverpod?"** — Have the Story 5 answer ready. Frame it as a deliberate fit-for-purpose decision, not avoidance.
2. **"How do you handle real-time updates?"** — Acknowledge you use one-shot reads; sketch the stream-based migration.
3. **"Show me a test that's hard to write."** — Point at the `ReadingProgressViewModel` widget test — proves a non-obvious perf invariant (no notify under threshold).
4. **"What would you do differently if you started today?"** — `freezed` for entities, `--dart-define` for secrets, sealed classes for `HomeNavigationTarget`.
5. **"How would this scale to a 20-person team?"** — Feature folders mean teams own features; the domain/data contract means a backend swap doesn't ripple; CI + codegen would be the first additions.

---

## Part 8 — Mock Interview Questions

### Beginner

**Q1. Walk me through what happens when a user clicks "Subscribe" on your newsletter form.**
- Form `onPressed` → `controller.subscribe()`
- Validates via `formKey.currentState?.validate()`
- Calls `subscribeWithEmail(...)` → `subscribeCommand.start()` (sets `isLoading=true`, notifies)
- `_newsletterRepository.subscribe(email)` returns `Either<Failure, SubscriptionResult>`
- `result.fold` → either `setError(...)` or `setData(...)`
- Widget's `_handleSubscribeFeedback` listener fires snackbar
- Files: `newsletter_controller.dart`, `newsletter_subscribe_widget.dart`

**Q2. What's the difference between `StatelessWidget` and `StatefulWidget` and how do you decide?**
- Stateless when the widget is a pure function of its inputs.
- Stateful when you need `initState` / `dispose` — usually for owning a listener, a `TextEditingController`, or kicking off an async load.
- Example: `NewsletterSubscribeWidget` is Stateful because it attaches/detaches a Command listener; `CustomTextField` is Stateless because the parent owns the `TextEditingController`.

### Intermediate

**Q3. Walk me through your error handling story end to end.**
- Three layers (see Part 5, item 20).
- Repository wraps Firestore in `FirestoreRequestHandler.run<T>` — typed `Failure` returned.
- Domain returns `Either<Failure, T>` via `dartz`.
- Controller does `result.fold(setError, setData)`, with `mapFailureToMessage` for user copy.
- *"No exceptions cross the data boundary."*

**Q4. How do you do dependency injection? Why not just `new` everything?**
- `get_it` as service locator at the composition root only (`service_locator.dart`).
- Everywhere else: constructor injection.
- Singletons for stateful collaborators (repos, services); factories for controllers.
- Why not `new`: testability. Mock/fake repos in tests is one line.

**Q5. Your `Command<T>` — what's the design behind it? Why this, not Bloc?**
- 40-line `ChangeNotifier` subclass exposing `isLoading / data / error`.
- View binds via `ListenableBuilder`.
- Bloc adds events + states + transitions, which is overkill for a content site.
- Bloc would win at a larger scale; Command is migratable per-feature.

### Senior

**Q6. Where in your code would you struggle if requirements changed to "every action must work offline"?**
- Honestly: the repository layer abstracts the data source, so a `CachedBlogListRepository` decorator is plausible — wrap a remote repo with a local cache.
- But `BlogEngagementLocalStore` is web-only via `universal_html`. Mobile would need a `SharedPreferences`-backed implementation behind a new interface.
- The `Either<Failure, T>` envelope makes "served from cache" a possible third branch — though typed states might be cleaner than Either at that point.

**Q7. Critique your own architecture — what's the weakest part?**
- `BlogDetailRepository` has 5 methods serving one client; tolerable but watch for split.
- Custom `Command<T>` means new devs have a learning curve before they touch a feature.
- `HomeNavigationTarget` is a hand-rolled union — should be a sealed class.
- `flutter_bloc` in pubspec but unused (admit if you've already cleaned it up).

**Q8. You're adding a "save for later" feature on blog posts that needs to sync across devices. How would you design it?**
- New domain entity: `SavedPost { postId, savedAt, deviceId }`.
- New `SavedPostsRepository` abstract; implementation backed by Firestore subcollection under the user.
- Need a user identity — either anonymous Firebase Auth or device-based ID.
- Local cache for offline: `Stream<List<SavedPost>>` from `.snapshots()` — this would be your first stream-based feature.
- New controller `SavedPostsController` exposing a Command + the live stream.

**Q9. How does your code support adding a second platform (e.g. mobile)?**
- Feature folders + domain abstractions mean business logic moves over unchanged.
- `BlogEngagementLocalStore` would need a platform adapter (SharedPreferences for mobile).
- `PortfolioScrollBehavior` would need to drop the smooth-wheel path on touch devices (it already does — `shouldEnableSmoothWheelScroll` returns false on iOS/Android).
- Routing via `go_router` is platform-agnostic.

**Q10. The hiring manager says "we have 20 Flutter devs and the codebase is getting tangled." What would you propose first, based on what you've built here?**
- Enforce the data/domain/presentation boundary with a custom analyzer rule (or `import_lint`).
- Codify ownership at the feature folder level so PRs route automatically.
- Generate models — `freezed` removes the copyWith/equality boilerplate that bloats entity files.
- Treat the composition root as a hot file — review every `service_locator` change.
- Tests at the controller boundary, not in widgets — fast and stable.

---

## Part 9 — One-line Cheat Sheet

If you forget everything else, anchor to these:

- **Architecture:** Feature-first Clean Architecture (data/domain/presentation), domain is pure Dart.
- **State:** Custom `Command<T> extends ChangeNotifier`, views bind via `ListenableBuilder`.
- **DI:** `get_it` at the composition root, constructor injection everywhere else.
- **Errors:** Either<Failure, T> from data layer up, typed Failure subclasses, central mapper to user copy.
- **Patterns:** Repository, Strategy (launcher, sort), Adapter (Document→Entity), Factory (constructors), Observer (Command).
- **Tests:** Mockito-generated mocks for repos, hand-rolled fakes for simpler cases, widget tests for ViewModels.
- **Trade-off I'd defend:** Picked a 40-line custom Command over Bloc to keep boilerplate low — it's migratable per-feature.

Good luck. You know this code — they don't.
