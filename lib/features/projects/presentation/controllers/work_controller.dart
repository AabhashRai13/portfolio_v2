import 'package:my_portfolio/core/resources/utils/static_utils.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

class WorkController {
  WorkController({
    required AppLaunchService launchService,
    required ProjectsRepository projectsRepository,
  }) : _launchService = launchService,
       _projectsRepository = projectsRepository;

  final AppLaunchService _launchService;
  final ProjectsRepository _projectsRepository;

  late final List<ProjectSummary> projects = _projectsRepository
      .getFeaturedProjects();

  late final List<ProjectSummary> flagships = projects
      .where((project) => project.flagship)
      .toList();

  Future<void> openProject(ProjectSummary project) =>
      _launchService.openExternalUrl(project.link);

  Future<void> openSource() =>
      _launchService.openExternalUrl(StaticUtils.gitHub);
}
