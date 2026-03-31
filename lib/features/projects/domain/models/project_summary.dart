class ProjectSummary {
  const ProjectSummary({
    required this.title,
    required this.summary,
    required this.link,
    this.banner,
    this.icon,
  });

  final String title;
  final String summary;
  final String link;
  final String? banner;
  final String? icon;
}
