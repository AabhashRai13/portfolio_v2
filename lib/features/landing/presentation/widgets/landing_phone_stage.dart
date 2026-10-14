import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/contact/presentation/views/phone_contact_form.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_screen_view_model.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_phone.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';

/// [LandingPhoneScreenViewModel] decides.
class LandingPhoneStage extends StatefulWidget {
  const LandingPhoneStage({
    required this.motion,
    required this.onOpenWidget,
    this.entrance,
    super.key,
  });

  final LandingPhoneMotionController motion;
  final ValueChanged<SiteSection> onOpenWidget;
  final Animation<double>? entrance;

  @override
  State<LandingPhoneStage> createState() => _LandingPhoneStageState();
}

/// Owns the screen view model's lifetime.
class _LandingPhoneStageState extends State<LandingPhoneStage> {
  late final _screen = LandingPhoneScreenViewModel(motion: widget.motion);

  @override
  void dispose() {
    _screen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _screen,
      builder: (context, _) => LandingPhone(
        motion: widget.motion,
        interactive: !_screen.contactOpen,
        child: AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _screen.contactOpen
              ? PhoneContactForm(
                  key: const ValueKey<String>('phone-contact-form'),
                  onClose: _screen.closeContact,
                )
              : LandingWidgetGrid(
                  key: const ValueKey<String>('phone-widget-grid'),
                  entrance: widget.entrance,
                  onOpen: (section) =>
                      _screen.open(section, navigate: widget.onOpenWidget),
                ),
        ),
      ),
    );
  }
}
