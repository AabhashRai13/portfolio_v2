import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/content/domain/models/case_study_preview.dart';
import 'package:my_portfolio/features/content/domain/repositories/content_repository.dart';
import 'package:my_portfolio/features/home/presentation/models/home_section.dart';
import 'package:my_portfolio/features/home/presentation/view_models/home_view_model.dart';
import 'package:my_portfolio/features/portfolio/domain/models/project_summary.dart';

void main() {
  group('HomeViewModel', () {
    test('loads featured projects from content repository', () {
      final viewModel = HomeViewModel(
        launchService: _RecordingLaunchService(),
        contentRepository: const _FakeContentRepository(),
      );

      expect(viewModel.featuredProjects, hasLength(1));
      expect(viewModel.featuredProjects.first.title, 'Demo Project');
    });

    test('navigation selection scrolls to mapped section', () async {
      final viewModel = HomeViewModel(
        launchService: _RecordingLaunchService(),
        contentRepository: const _FakeContentRepository(),
      );

      HomeSection? selectedSection;

      await viewModel.handleNavigationSelection(
        4,
        scrollToSection: (section) => selectedSection = section,
      );

      expect(selectedSection, HomeSection.contact);
    });

    test(
      'resume navigation opens external link instead of scrolling',
      () async {
      final launchService = _RecordingLaunchService();
      final viewModel = HomeViewModel(
        launchService: launchService,
        contentRepository: const _FakeContentRepository(),
      );

      var didScroll = false;

      await viewModel.handleNavigationSelection(
        5,
        scrollToSection: (_) => didScroll = true,
      );

      expect(didScroll, isFalse);
      expect(launchService.openedUrls, isNotEmpty);
      },
    );
  });
}

class _RecordingLaunchService implements AppLaunchService {
  final List<String> openedUrls = <String>[];

  @override
  Future<void> openExternalUrl(String url) async {
    openedUrls.add(url);
  }
}

class _FakeContentRepository implements ContentRepository {
  const _FakeContentRepository();

  @override
  List<CaseStudyPreview> getCaseStudies() {
    return const <CaseStudyPreview>[];
  }

  @override
  List<ProjectSummary> getFeaturedProjects() {
    return const <ProjectSummary>[
      ProjectSummary(
        title: 'Demo Project',
        link: 'https://example.com',
      ),
    ];
  }
}
