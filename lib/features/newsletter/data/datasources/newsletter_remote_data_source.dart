import 'package:cloud_functions/cloud_functions.dart';

class NewsletterRemoteDataSource {
  NewsletterRemoteDataSource({
    required FirebaseFunctions functions,
  }) : _functions = functions;

  static const String subscribeFunctionName = 'subscribeToNewsletter';

  final FirebaseFunctions _functions;

  Future<Object?> subscribe(String email) async {
    final response = await _functions
        .httpsCallable(subscribeFunctionName)
        .call<Object?>(<String, String>{'email': email});
    return response.data;
  }
}
