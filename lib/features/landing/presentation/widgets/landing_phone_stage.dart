import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/contact/presentation/views/phone_contact_form.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_phone.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';

/// Desktop phone whose screen switches from the widget grid to the contact
/// form. While the form is open the phone holds its forward-facing pose and
/// ignores drag, so typing and scrolling never move it.
class LandingPhoneStage extends StatefulWidget {
  const LandingPhoneStage({
    required this.motion,
    required this.onOpenWidget,
    this.entrance,
    super.key,
  });

  final LandingPhoneMotionController motion;

  /// Called for every tile except Contact, which opens inside the phone.
  final ValueChanged<SiteSection> onOpenWidget;
  final Animation<double>? entrance;

  @override
  State<LandingPhoneStage> createState() => _LandingPhoneStageState();
}

class _LandingPhoneStageState extends State<LandingPhoneStage> {
  bool _contactOpen = false;

  void _setContactOpen({required bool open}) {
    if (_contactOpen == open) return;
    setState(() => _contactOpen = open);
    widget.motion.setLocked(isLocked: open);
  }

  @override
  void dispose() {
    // The motion controller outlives this stage (e.g. resizing to mobile).
    if (_contactOpen) widget.motion.setLocked(isLocked: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LandingPhone(
      motion: widget.motion,
      interactive: !_contactOpen,
      child: AnimatedSwitcher(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _contactOpen
            ? PhoneContactForm(
                key: const ValueKey<String>('phone-contact-form'),
                onClose: () => _setContactOpen(open: false),
              )
            : LandingWidgetGrid(
                key: const ValueKey<String>('phone-widget-grid'),
                entrance: widget.entrance,
                onOpen: (section) => section == SiteSection.contact
                    ? _setContactOpen(open: true)
                    : widget.onOpenWidget(section),
              ),
      ),
    );
  }
}
