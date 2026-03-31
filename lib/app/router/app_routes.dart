abstract final class AppRoutes {
  static const String home = '/';
  static const String blog = '/blog';
  static const String blogDetail = '/blog/:slug';
  static const String content = '/content';

  static String blogPost(String slug) => '$blog/$slug';
}
