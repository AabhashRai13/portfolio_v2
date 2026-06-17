import 'package:flutter/widgets.dart';

/// Exposes a `[0, 1]` reading progress derived from a [ScrollController].
///
/// Owned by the view (constructed in `initState`, disposed in `dispose`) so
/// the widget that renders the bar stays stateless.
class ReadingProgressViewModel extends ChangeNotifier {
  ReadingProgressViewModel({required ScrollController scrollController})
      : _scrollController = scrollController {
    _scrollController.addListener(_onScroll);
  }

  final ScrollController _scrollController;

  /// Minimum delta before the viewmodel notifies — avoids rebuilds that
  /// wouldn't move a single pixel on the bar.
  static const double _minDelta = 0.002;

  double _progress = 0;
  double get progress => _progress;

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    final next = max <= 0 ? 0.0 : (position.pixels / max).clamp(0.0, 1.0);

    final resetToZero = next == 0 && _progress != 0;
    if ((next - _progress).abs() < _minDelta && !resetToZero) {
      return;
    }
    _progress = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }
}
