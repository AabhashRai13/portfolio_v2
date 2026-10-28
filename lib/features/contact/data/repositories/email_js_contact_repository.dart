import 'dart:async';

import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:my_portfolio/core/services/site_analytics_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/keys.dart';

class EmailJsContactRepository implements ContactRepository {
  EmailJsContactRepository({required SiteAnalyticsService analytics})
    : _analytics = analytics;

  final SiteAnalyticsService _analytics;

  @override
  Future<void> submitContactMessage(ContactMessage message) async {
    await emailjs.send(
      emailJsServiceId,
      emailJsTemplateId,
      message.toTemplateParams(),
      const emailjs.Options(
        publicKey: emailJsPublicKey,
        privateKey: emailJsPrivateKey,
      ),
    );
    // Only a delivered message counts; the send above throws otherwise.
    unawaited(_analytics.logContactSubmitted());
  }
}
