import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/firestore_request_handler.dart';

void main() {
  test('waits for Firebase before running the request', () async {
    final firebaseReady = Completer<void>();
    var requested = false;
    final handler = FirestoreRequestHandler(
      ready: () => firebaseReady.future,
    );

    final result = handler.run<int>(
      request: () async {
        requested = true;
        return 1;
      },
      operation: 'test',
      fallbackMessage: 'failed',
    );
    await Future<void>.delayed(Duration.zero);
    expect(requested, isFalse);

    firebaseReady.complete();
    expect((await result).isRight(), isTrue);
    expect(requested, isTrue);
  });

  test('a failed Firebase start becomes a failure, not a crash', () async {
    var requested = false;
    final handler = FirestoreRequestHandler(
      ready: () async => throw Exception('offline'),
    );

    final result = await handler.run<int>(
      request: () async {
        requested = true;
        return 1;
      },
      operation: 'test',
      fallbackMessage: 'failed',
    );

    expect(result.isLeft(), isTrue);
    expect(requested, isFalse);
  });
}
