import 'dart:async';

import 'package:flutter/services.dart';
import 'package:my_portfolio/core/services/tap_sound/tap_sound_stub.dart'
    if (dart.library.js_interop) 'package:my_portfolio/core/services/tap_sound/tap_sound_web.dart';

/// Light feedback for carousel and project-view buttons: a 10 ms buzz on
/// Android browsers (iOS Safari does not let pages vibrate) and a quiet
/// "tuk" wherever the browser allows sound.
void tapFeedback() {
  unawaited(HapticFeedback.selectionClick());
  playTapSound();
}
