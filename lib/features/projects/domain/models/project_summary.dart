class ProjectSummary {
  const ProjectSummary({
    required this.title,
    required this.role,
    required this.problem,
    required this.built,
    required this.result,
    required this.stack,
    required this.links,
    required this.banner,
  });

  final String title;

  /// Role only, never the employer, e.g. "Solo developer · design to release".
  final String role;

  /// The three bullets every project shows, in this order: the problem the
  /// app solves, what was built, and the outcome (no downloads or ratings).
  final String problem;
  final String built;
  final String result;

  /// One plain line, e.g. "Kotlin · Jetpack Compose · Room".
  final String stack;

  /// Store pages, each shown as its own link.
  final List<String> links;

  /// Poster drawn at the carousel's 0.78 width / height.
  final String banner;
}
