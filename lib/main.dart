import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:my_portfolio/app/app.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/core/services/firebase_app_check_service.dart';
import 'package:my_portfolio/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDependencies();
  await getIt.get<FirebaseAppCheckService>().activate();
  runApp(const PortfolioApp());
}
