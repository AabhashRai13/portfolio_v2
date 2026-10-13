import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_grid_view_model.dart';

void main() {
  late List<SiteSection> opened;
  late List<double> notes;

  LandingGridViewModel create({bool tearDown = true}) {
    final viewModel = LandingGridViewModel(
      onOpen: opened.add,
      feedback: ({pitch = 1}) => notes.add(pitch),
    );
    if (tearDown) addTearDown(viewModel.dispose);
    return viewModel;
  }

  void press(LandingGridViewModel viewModel, SiteSection section) =>
      viewModel.pointerDown(
        section,
        position: Offset.zero,
        buttons: kPrimaryButton,
      );

  setUp(() {
    opened = [];
    notes = [];
  });

  group('hover and focus', () {
    test('hovering one tile grows it and shrinks the rest', () {
      final viewModel = create()..setHovered(SiteSection.work, isHovered: true);
      expect(viewModel.isActive(SiteSection.work), isTrue);
      expect(viewModel.hoverScaleFor(SiteSection.work), 1.04);
      expect(viewModel.hoverScaleFor(SiteSection.about), 0.94);

      viewModel.setHovered(SiteSection.work, isHovered: false);
      expect(viewModel.hoverScaleFor(SiteSection.work), 1);
      expect(viewModel.hoverScaleFor(SiteSection.about), 1);
    });

    test('focus makes a tile active when nothing is hovered', () {
      final viewModel = create()
        ..setFocused(SiteSection.about, isFocused: true);
      expect(viewModel.isFocused(SiteSection.about), isTrue);
      expect(viewModel.isActive(SiteSection.about), isTrue);
    });
  });

  group('press', () {
    test('a primary press squishes the tile until release', () {
      final viewModel = create();
      press(viewModel, SiteSection.work);
      expect(viewModel.isPressed(SiteSection.work), isTrue);
      expect(
        viewModel.pressScaleFor(SiteSection.work),
        LandingGridViewModel.pressedScale,
      );
      expect(viewModel.pressScaleFor(SiteSection.about), 1);

      viewModel.pointerUp(SiteSection.work);
      expect(viewModel.isPressed(SiteSection.work), isFalse);
    });

    test('another mouse button does not press', () {
      final viewModel = create()
        ..pointerDown(
          SiteSection.work,
          position: Offset.zero,
          buttons: kSecondaryButton,
        );
      expect(viewModel.isPressed(SiteSection.work), isFalse);
    });

    test('moving past the touch slop is a drag and lets go', () {
      final viewModel = create();
      press(viewModel, SiteSection.work);
      viewModel.pointerMove(SiteSection.work, const Offset(kTouchSlop - 1, 0));
      expect(viewModel.isPressed(SiteSection.work), isTrue);

      viewModel.pointerMove(SiteSection.work, const Offset(kTouchSlop + 1, 0));
      expect(viewModel.isPressed(SiteSection.work), isFalse);
    });
  });

  group('open', () {
    testWidgets('a tap plays its note and opens a beat later', (tester) async {
      final viewModel = create();
      press(viewModel, SiteSection.about);
      viewModel
        ..pointerUp(SiteSection.about)
        ..activate(SiteSection.about);

      expect(notes, [LandingGridViewModel.pitchFor(SiteSection.about)]);
      expect(opened, isEmpty);
      // A finger already pressed and let go; no extra key squish.
      expect(viewModel.isPressed(SiteSection.about), isFalse);

      await tester.pump(LandingGridViewModel.openDelay);
      expect(opened, [SiteSection.about]);
    });

    testWidgets('taps during the beat are ignored', (tester) async {
      create()
        ..activate(SiteSection.work)
        ..activate(SiteSection.about);
      await tester.pump(LandingGridViewModel.openDelay);

      expect(notes, hasLength(1));
      expect(opened, [SiteSection.work]);
    });

    testWidgets('a key press squishes the tile for a moment', (tester) async {
      final viewModel = create()..activate(SiteSection.writing);
      expect(viewModel.isPressed(SiteSection.writing), isTrue);

      await tester.pump(LandingGridViewModel.keyPressHold);
      expect(viewModel.isPressed(SiteSection.writing), isFalse);
      await tester.pump(LandingGridViewModel.openDelay);
    });

    testWidgets('a key press after a drag still squishes', (tester) async {
      final viewModel = create();
      press(viewModel, SiteSection.work);
      viewModel
        ..pointerMove(SiteSection.work, const Offset(kTouchSlop + 1, 0))
        ..activate(SiteSection.about);
      expect(viewModel.isPressed(SiteSection.about), isTrue);
      await tester.pump(LandingGridViewModel.openDelay);
    });

    test('with reduced motion the page opens straight away', () {
      create()
        ..reduceMotion = true
        ..activate(SiteSection.work);
      expect(opened, [SiteSection.work]);
    });

    testWidgets('disposing during the beat cancels the open', (tester) async {
      create(tearDown: false)
        ..activate(SiteSection.work)
        ..dispose();
      await tester.pump(LandingGridViewModel.openDelay);
      expect(opened, isEmpty);
    });

    testWidgets('opens through the latest onOpen', (tester) async {
      final later = <SiteSection>[];
      create()
        ..activate(SiteSection.work)
        ..onOpen = later.add;
      await tester.pump(LandingGridViewModel.openDelay);
      expect(opened, isEmpty);
      expect(later, [SiteSection.work]);
    });
  });

  test('each tile plays its own note, highest at Work', () {
    final pitches = [
      for (final section in SiteSection.values)
        LandingGridViewModel.pitchFor(section),
    ];
    expect(pitches.toSet(), hasLength(SiteSection.values.length));
    expect(pitches, [...pitches]..sort((a, b) => b.compareTo(a)));
    // Contact keeps the Work carousel arrows' own note.
    expect(LandingGridViewModel.pitchFor(SiteSection.contact), 1);
  });
}
