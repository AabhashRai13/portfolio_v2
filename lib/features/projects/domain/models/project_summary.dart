class ProjectSummary {
  const ProjectSummary({
    required this.title,
    required this.summary,
    required this.link,
    this.role,
    this.result,
    this.banner,
    this.icon,
    this.flagship = false,
  });

  final String title;
  final String summary;
  final String link;

  /// Role and company, e.g. "Senior mobile developer · Pegotec".
  final String? role;

  /// Measurable outcome, e.g. "10K+ downloads · 4.6★".
  final String? result;
  final String? banner;
  final String? icon;

  /// Shown in the Work page carousel; everything appears on /work/all.
  final bool flagship;
}
