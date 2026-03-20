import 'package:my_portfolio/features/content/domain/models/case_study_preview.dart';
import 'package:my_portfolio/features/portfolio/domain/models/project_summary.dart';

abstract class ContentRepository {
  List<ProjectSummary> getFeaturedProjects();
  List<CaseStudyPreview> getCaseStudies();
}
