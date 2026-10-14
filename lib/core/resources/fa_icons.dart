import 'package:flutter/widgets.dart';

// ponytail: font_awesome_flutter 11 wraps icons in FaIconData, which hides
// them from Flutter's web icon tree shaker, so their glyphs get stripped from
// the font (fluttercommunity/font_awesome_flutter#301). Plain const IconData is
// still detected, so the icons we use live here and are wrapped in FaIconData
// at render time. Delete this file and use FontAwesomeIcons once #301 is fixed.
abstract final class FaIcons {
  static const flutter = IconData(
    0xe694,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const github = IconData(
    0xf09b,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const linkedin = IconData(
    0xf08c,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const instagram = IconData(
    0xf16d,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const apple = IconData(0xf179, fontFamily: _brands, fontPackage: _pkg);
  static const android = IconData(
    0xf17b,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const stripe = IconData(
    0xf42a,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const applePay = IconData(
    0xf415,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const googlePay = IconData(
    0xe079,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const nodeJs = IconData(
    0xf3d3,
    fontFamily: _brands,
    fontPackage: _pkg,
  );
  static const vial = IconData(0xf492, fontFamily: _solid, fontPackage: _pkg);
  static const codeBranch = IconData(
    0xf126,
    fontFamily: _solid,
    fontPackage: _pkg,
  );
  static const _brands = 'FontAwesomeBrands';
  static const _solid = 'FontAwesomeSolid';
  static const _pkg = 'font_awesome_flutter';
}
