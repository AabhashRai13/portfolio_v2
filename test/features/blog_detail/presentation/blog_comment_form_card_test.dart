import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/features/blog_detail/domain/usecases/get_blog_post_use_case.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_comment_form_card.dart';

import '../blog_detail_mocks.mocks.dart';

void main() {
  late BlogPostDetailController controller;

  setUp(() {
    final repo = MockBlogDetailRepository();
    controller = BlogPostDetailController(
      getBlogPost: GetBlogPostUseCase(repository: repo),
      blogDetailRepository: repo,
      launchService: MockAppLaunchService(),
    );
    addTearDown(controller.dispose);
  });

  // 276 px is the card's content width on a 390 px phone, where the
  // heading row used to overflow by 18 px.
  for (final width in const [276.0, 220.0]) {
    testWidgets('heading fits a $width px wide card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: kLightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  // Plus the card's own 32 px padding either side.
                  width: width + 64,
                  child: BlogCommentFormCard(controller: controller),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Leave a Comment'), findsOneWidget);
    });
  }
}
