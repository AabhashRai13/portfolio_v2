import 'package:my_portfolio/features/content/domain/models/case_study_preview.dart';
import 'package:my_portfolio/features/content/domain/repositories/content_repository.dart';
import 'package:my_portfolio/features/portfolio/domain/models/project_summary.dart';
import 'package:my_portfolio/utils/project_utils.dart';

class StaticContentRepository implements ContentRepository {
  @override
  List<ProjectSummary> getFeaturedProjects() {
    return List<ProjectSummary>.generate(ProjectUtils.titles.length, (index) {
      return ProjectSummary(
        title: ProjectUtils.titles[index],
        banner: ProjectUtils.banners[index],
        icon: ProjectUtils.icons[index],
        link: ProjectUtils.links[index],
      );
    });
  }

  @override
  List<CaseStudyPreview> getCaseStudies() {
    return const <CaseStudyPreview>[
      CaseStudyPreview(
        slug: 'coming-soon',
        title: 'Case studies coming soon',
        summary: 'This route is reserved for future content-driven pages.',
      ),
    ];
  }
}
