import 'dart:math';

import 'package:universal_html/html.dart' as html;

class BlogEngagementLocalStore {
  static const String _browserIdKey = 'blog.browserId';
  static const String _sessionIdKey = 'blog.sessionId';

  String browserId() {
    final storage = html.window.localStorage;
    final existing = storage[_browserIdKey];
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final generated = _generateId();
    storage[_browserIdKey] = generated;
    return generated;
  }

  String sessionId() {
    final storage = html.window.sessionStorage;
    final existing = storage[_sessionIdKey];
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final generated = _generateId();
    storage[_sessionIdKey] = generated;
    return generated;
  }

  bool hasLiked(String slug) {
    return html.window.localStorage[_likedKey(slug)] == 'true';
  }

  void markLiked(String slug) {
    html.window.localStorage[_likedKey(slug)] = 'true';
  }

  bool hasRecordedView(String slug) {
    return html.window.sessionStorage[_viewedKey(slug)] == 'true';
  }

  void markViewRecorded(String slug) {
    html.window.sessionStorage[_viewedKey(slug)] = 'true';
  }

  String _likedKey(String slug) => 'blog.liked.$slug';
  String _viewedKey(String slug) => 'blog.viewed.$slug';

  String _generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    final random = Random();
    final suffix = List<String>.generate(
      4,
      (_) => random.nextInt(0x10000).toRadixString(16).padLeft(4, '0'),
      growable: false,
    ).join();

    return '$timestamp$suffix';
  }
}
