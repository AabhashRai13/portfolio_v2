// ignore_for_file: document_ignores
// This repository stays abstract on purpose so project data can evolve from
// static mocks to another source without touching the home/project UI.

import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

abstract class ProjectsRepository {
  List<FeaturedProject> getFeaturedProjects();

  /// Featured first, then the rest.
  List<ProjectSummary> getAllProjects();
}
