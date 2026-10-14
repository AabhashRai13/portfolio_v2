import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/newsletter/data/datasources/newsletter_remote_data_source.dart';

void main() {
  test('can be created before Firebase is up', () {
    var resolved = false;
    NewsletterRemoteDataSource(
      functions: () {
        resolved = true;
        throw StateError('Firebase is not up');
      },
      ready: () async {},
    );

    expect(resolved, isFalse);
  });

  test('waits for Firebase before calling the function', () async {
    final firebaseReady = Completer<void>();
    var resolved = false;
    final dataSource = NewsletterRemoteDataSource(
      functions: () {
        resolved = true;
        // Stops the call here; reaching this point is what the test checks.
        throw FirebaseFunctionsException(message: 'stop', code: 'internal');
      },
      ready: () => firebaseReady.future,
    );

    final call = dataSource.subscribe('aabhash@example.com');
    await Future<void>.delayed(Duration.zero);
    expect(resolved, isFalse);

    firebaseReady.complete();
    await expectLater(call, throwsA(isA<FirebaseFunctionsException>()));
    expect(resolved, isTrue);
  });
}
