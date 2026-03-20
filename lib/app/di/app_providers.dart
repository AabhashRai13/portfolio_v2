import 'package:flutter/widgets.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/data/repositories/email_js_contact_repository.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/domain/usecases/submit_contact_message_use_case.dart';
import 'package:my_portfolio/features/content/data/repositories/static_content_repository.dart';
import 'package:my_portfolio/features/content/domain/repositories/content_repository.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppLaunchService>(
          create: (_) => const UrlLauncherAppLaunchService(),
        ),
        Provider<ContactRepository>(
          create: (_) => EmailJsContactRepository(),
        ),
        Provider<ContentRepository>(
          create: (_) => StaticContentRepository(),
        ),
        Provider<SubmitContactMessageUseCase>(
          create: (context) => SubmitContactMessageUseCase(
            context.read<ContactRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
