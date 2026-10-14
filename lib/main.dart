import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:my_portfolio/app/app.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/core/services/firebase_bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  setupDependencies();
  runApp(const PortfolioApp());
  // Paint first; warm Firebase up so Writing usually finds it ready.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    getIt.get<FirebaseBootstrap>().ensureInitialized().catchError(
      (Object error) => log('Firebase warm-up failed', error: error),
    );
  });
}
