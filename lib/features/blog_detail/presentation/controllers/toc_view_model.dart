import 'package:flutter/widgets.dart';
import 'package:my_portfolio/core/services/smooth_wheel_scroll_controller.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';

/// Scroll-driven state for the table of contents.
///
/// Holds the list of headings, tracks which one is currently active based
/// on scroll position, and exposes a single `scrollToHeading` action so the
/// TOC widgets stay dumb.
class TocViewModel extends ChangeNotifier {
  TocViewModel({
    required SmoothWheelScrollController scrollController,
    required this.headings,
    required this.headingKeys,
    this.topPadding = 100,
  }) : _scrollController = scrollController {
    _scrollController.addListener(_onScroll);
  }

  final SmoothWheelScrollController _scrollController;
  final List<TocHeading> headings;
  final Map<String, GlobalKey> headingKeys;
  final double topPadding;

  int _activeIndex = 0;
  int get activeIndex => _activeIndex;

  void _onScroll() {
    final next = _computeActiveIndex();
    if (next != _activeIndex) {
      _activeIndex = next;
      notifyListeners();
    }
  }

  int _computeActiveIndex() {
    var lastVisible = 0;
    for (var i = 0; i < headings.length; i++) {
      final key = headingKeys[headings[i].id];
      if (key == null) continue;

      final ctx = key.currentContext;
      if (ctx == null) continue;

      final renderObject = ctx.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) continue;

      final offset = renderObject.localToGlobal(Offset.zero);
      if (offset.dy <= topPadding) {
        lastVisible = i;
      } else {
        break;
      }
    }
    return lastVisible;
  }

  Future<void> scrollToHeading(int index) async {
    if (index < 0 || index >= headings.length) return;
    final key = headingKeys[headings[index].id];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.05,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _scrollController.resetWheelTarget();
  }

  Future<void> scrollToHeadingById(String id) {
    final index = headings.indexWhere((h) => h.id == id);
    return scrollToHeading(index);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }
}
