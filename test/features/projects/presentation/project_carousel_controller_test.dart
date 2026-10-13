import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/projects/data/static_project_summaries.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/project_carousel_controller.dart';

void main() {
  late ProjectCarouselController carousel;

  setUp(() {
    carousel = ProjectCarouselController(
      projects: featuredProjects,
      onOpen: (_, _) async {},
    )..sync(layout: CarouselLayout.desktop, reduceMotion: true);
    addTearDown(carousel.dispose);
  });

  test('starts deep in the endless list on the first project', () {
    expect(carousel.index, featuredProjects.length * 1000);
    expect(carousel.selected, 0);
  });

  test('a pill takes the shorter way round to its project', () {
    final start = carousel.index;
    expect(carousel.nearestPageFor(1), start + 1);
    // Project 2 of 3 is one step back, not two forward.
    expect(carousel.nearestPageFor(2), start - 1);
    expect(carousel.nearestPageFor(0), start);
  });

  test('only a mostly horizontal scroll belongs to the carousel', () {
    expect(carousel.claimsScroll(const Offset(30, 5)), isTrue);
    expect(carousel.claimsScroll(const Offset(5, 30)), isFalse);
    expect(carousel.claimsScroll(const Offset(10, 10)), isFalse);
  });

  testWidgets('a trackpad swipe turns one page per burst', (tester) async {
    expect(carousel.wheel(15), 0);
    expect(carousel.wheel(15), 0);
    expect(carousel.wheel(15), 1);
    // The momentum tail of the same swipe is ignored.
    expect(carousel.wheel(60), 0);

    await tester.pump(const Duration(milliseconds: 250));
    expect(carousel.wheel(-45), -1);
    await tester.pump(const Duration(milliseconds: 250));
  });

  testWidgets('switching layout keeps the current page', (tester) async {
    final desktop = carousel.pageController;
    carousel.sync(layout: CarouselLayout.phone, reduceMotion: true);

    expect(carousel.layout, CarouselLayout.phone);
    expect(carousel.pageController, isNot(same(desktop)));
    expect(carousel.pageController.viewportFraction, 0.74);
    expect(carousel.pageController.initialPage, desktop.initialPage);
    // The old controller goes after the frame that stops using it.
    await tester.pump();
  });

  test('a card at rest is fully lifted and the caption fully shown', () {
    final middle = carousel.index;
    expect(carousel.distanceOf(middle), 0);
    expect(carousel.scaleOf(middle), CarouselLayout.desktop.centerScale);
    expect(carousel.scaleOf(middle + 1), CarouselLayout.desktop.sideScale);
    expect(carousel.captionOpacity, 1);
  });
}
