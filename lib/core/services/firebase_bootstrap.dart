/// Brings Firebase up once, on first use, so the first frame never waits on
/// it. A failed attempt is forgotten so the next caller can retry.
class FirebaseBootstrap {
  FirebaseBootstrap({required Future<void> Function() initialize})
    : _initialize = initialize;

  final Future<void> Function() _initialize;
  Future<void>? _ready;

  Future<void> ensureInitialized() {
    return _ready ??= _initialize().catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      _ready = null;
      Error.throwWithStackTrace(error, stackTrace);
    });
  }
}
