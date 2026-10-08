/// Screen widths where the site's page layouts change. Every page reads
/// these, so the whole site switches at the same points:
///
/// | Width       | Tier         |
/// |-------------|--------------|
/// | < 600       | phone        |
/// | 600 – 719   | small tablet |
/// | 720 – 999   | tablet       |
/// | 1000 – 1279 | desktop      |
/// | ≥ 1280      | wide desktop |
///
/// Widgets that size themselves to the space they are given (a card grid,
/// a blog card) decide from their own constraints instead.
abstract final class Breakpoints {
  /// Phones below this: tighter page padding and type, and no smooth
  /// mouse-wheel scrolling.
  static const double smallTablet = 600;

  /// Three posters fit side by side from here. Below it the Work carousel
  /// and the project view use their phone layouts, and the newsletter hero
  /// stacks.
  static const double tablet = 720;

  /// Desktop layouts from here: the full top bar, the landing page's phone
  /// mockup and the contact form as a side panel.
  static const double desktop = 1000;

  /// The landing page spreads out further from here.
  static const double wideDesktop = 1280;
}
