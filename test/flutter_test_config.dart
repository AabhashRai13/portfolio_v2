import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled site fonts so layout tests measure real glyph widths
/// instead of the 1-em-wide Ahem test font.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFont(
    'ArchivoExtraCondensed',
    'assets/fonts/ArchivoExtraCondensed-Black.ttf',
  );
  await _loadFont(
    'ArchivoCondensed',
    'assets/fonts/ArchivoCondensed-ExtraBold.ttf',
  );
  await _loadFont('IBMPlexMono', 'assets/fonts/IBMPlexMono-Medium.ttf');
  await testMain();
}

Future<void> _loadFont(String family, String asset) async {
  final loader = FontLoader(family)..addFont(rootBundle.load(asset));
  await loader.load();
}
