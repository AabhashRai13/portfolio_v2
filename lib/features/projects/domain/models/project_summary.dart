/// What every project shows in the All projects grid.
class ProjectSummary {
  const ProjectSummary({
    required this.title,
    required this.about,
    required this.icon,
    required this.links,
  });

  final String title;

  /// One line on what the app is, e.g. "Shared shopping list for couples".
  final String about;

  /// Square app icon.
  final String icon;

  /// Store pages; the grid opens the first, the project view shows them all.
  final List<String> links;
}

/// One of the apps built end to end: a poster in the Work carousel and three
/// bullets when opened.
class FeaturedProject extends ProjectSummary {
  const FeaturedProject({
    required super.title,
    required super.about,
    required super.icon,
    required super.links,
    required this.role,
    required this.problem,
    required this.built,
    required this.result,
    required this.stack,
    required this.banner,
  });

  /// Role only, never the employer, e.g. "Solo developer · design to release".
  final String role;

  /// The three bullets every featured project shows, in this order: the
  /// problem the app solves, what was built, and the outcome (no downloads
  /// or ratings).
  final String problem;
  final String built;
  final String result;

  /// One plain line, e.g. "Kotlin · Jetpack Compose · Room".
  final String stack;

  /// Poster drawn at the carousel's 0.78 width / height.
  final String banner;
}
