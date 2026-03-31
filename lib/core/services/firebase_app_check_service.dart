import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:my_portfolio/keys.dart';

class FirebaseAppCheckService {
  Future<void> activate() async {
    if (!kIsWeb) {
      return;
    }

    final host = Uri.base.host.trim().toLowerCase();
    final isLocalHost = host == 'localhost' || host == '127.0.0.1';

    if (kDebugMode && isLocalHost) {
      log(
        'Skipping Firebase App Check on local web debug.',
        name: 'FirebaseAppCheckService',
      );
      return;
    }

    if (firebaseAppCheckWebSiteKey.trim().isEmpty) {
      log(
        'Skipping Firebase App Check activation on web because the '
        'site key was not configured in keys.dart.',
        name: 'FirebaseAppCheckService',
      );
      return;
    }

    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaEnterpriseProvider(
        firebaseAppCheckWebSiteKey,
      ),
    );
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  }
}
