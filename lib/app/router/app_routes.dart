abstract final class AppRoutes {
  static const String home = '/';
  static const String work = '/work';
  static const String allWorkSegment = 'all';
  static const String allWork = '$work/$allWorkSegment';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String blog = '/blog';
  static const String blogDetailSegment = ':slug';
  static const String blogDetail = '$blog/$blogDetailSegment';
  static const String newsletter = '/newsletter';
  static const String content = '/content';

  static String blogPost(String slug) => '$blog/$slug';
}
