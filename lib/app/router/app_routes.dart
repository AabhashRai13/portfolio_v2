abstract final class AppRoutes {
  static const String home = '/';
  static const String blog = '/blog';
  static const String blogDetailSegment = ':slug';
  static const String blogDetail = '$blog/$blogDetailSegment';
  static const String content = '/content';

  static String blogPost(String slug) => '$blog/$slug';
}
