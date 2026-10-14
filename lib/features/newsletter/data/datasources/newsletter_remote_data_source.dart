import 'package:cloud_functions/cloud_functions.dart';

class NewsletterRemoteDataSource {
  NewsletterRemoteDataSource({
    required FirebaseFunctions Function() functions,
    required Future<void> Function() ready,
  }) : _functions = functions,
       _ready = ready;

  static const String subscribeFunctionName = 'subscribeToNewsletter';

  // Resolved per call: Firebase may not be up when this is created.
  final FirebaseFunctions Function() _functions;
  final Future<void> Function() _ready;

  Future<Object?> subscribe(String email) async {
    await _ready();
    final response = await _functions()
        .httpsCallable(subscribeFunctionName)
        .call<Object?>(<String, String>{'email': email});
    return response.data;
  }
}
