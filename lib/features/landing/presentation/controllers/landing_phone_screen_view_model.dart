import 'package:flutter/foundation.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';

/// What the desktop phone's screen shows: the tile grid, or the contact
/// form. While the form is open the phone holds its forward-facing pose and
/// ignores drag, so typing and scrolling never move it.
///
/// Owned by the phone stage (built in `initState`, disposed in `dispose`).
/// The phone's motion controller is borrowed and outlives it.
class LandingPhoneScreenViewModel extends ChangeNotifier {
  LandingPhoneScreenViewModel({required LandingPhoneMotionController motion})
    : _motion = motion;

  final LandingPhoneMotionController _motion;
  bool _contactOpen = false;

  bool get contactOpen => _contactOpen;

  /// A tile on the phone's screen: Contact opens right here, every other
  /// tile goes to its page through [navigate].
  void open(
    SiteSection section, {
    required ValueChanged<SiteSection> navigate,
  }) {
    if (section == SiteSection.contact) {
      openContact();
    } else {
      navigate(section);
    }
  }

  void openContact() => _setContactOpen(open: true);

  void closeContact() => _setContactOpen(open: false);

  void _setContactOpen({required bool open}) {
    if (_contactOpen == open) return;
    _contactOpen = open;
    _motion.setLocked(isLocked: open);
    notifyListeners();
  }

  /// Frees the phone if the stage goes away with the form open, e.g. when
  /// the window shrinks to the mobile layout.
  @override
  void dispose() {
    if (_contactOpen) _motion.setLocked(isLocked: false);
    super.dispose();
  }
}
