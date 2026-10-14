import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/firebase_bootstrap.dart';

void main() {
  test('does nothing until first asked', () {
    var calls = 0;
    FirebaseBootstrap(initialize: () async => calls++);

    expect(calls, 0);
  });

  test('initializes once, however many callers are waiting', () async {
    var calls = 0;
    final gate = Completer<void>();
    final bootstrap = FirebaseBootstrap(
      initialize: () {
        calls++;
        return gate.future;
      },
    );

    final first = bootstrap.ensureInitialized();
    final second = bootstrap.ensureInitialized();
    gate.complete();
    await Future.wait([first, second]);
    await bootstrap.ensureInitialized();

    expect(calls, 1);
  });

  test('a failed attempt is retried on the next call', () async {
    var calls = 0;
    final bootstrap = FirebaseBootstrap(
      initialize: () async {
        calls++;
        if (calls == 1) throw Exception('offline');
      },
    );

    await expectLater(bootstrap.ensureInitialized(), throwsException);
    await bootstrap.ensureInitialized();

    expect(calls, 2);
  });
}
