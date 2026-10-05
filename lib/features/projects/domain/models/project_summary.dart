class ProjectSummary {
  const ProjectSummary({
    required this.title,
    required this.role,
    required this.problem,
    required this.built,
    required this.result,
    required this.stack,
    required this.link,
    this.banner,
    this.icon,
    this.flagship = false,
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

  final String link;
  final String? banner;
  final String? icon;

  /// Shown in the Work page carousel; everything appears on /work/all.
  final bool flagship;
}
