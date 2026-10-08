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

  late final List<FeaturedProject> featured = _projectsRepository
      .getFeaturedProjects();

  late final List<ProjectSummary> all = _projectsRepository.getAllProjects();

  Future<void> openLink(String url) => _launchService.openExternalUrl(url);
}
