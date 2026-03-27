import 'package:my_portfolio/features/projects/data/static_project_summaries.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

class StaticProjectsRepository implements ProjectsRepository {
  @override
  List<ProjectSummary> getFeaturedProjects() {
    return staticProjectSummaries;
  }
}
