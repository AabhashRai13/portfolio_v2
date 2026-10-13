import 'dart:js_interop';

// Just enough of the Web Audio API for one short tone.
@JS('AudioContext')
extension type _AudioContext._(JSObject _) implements JSObject {
  external _AudioContext();
  external double get currentTime;
  external JSObject get destination;
  external _Oscillator createOscillator();
  external _Gain createGain();
}

extension type _Param._(JSObject _) implements JSObject {
  external void setValueAtTime(double value, double time);
  external void exponentialRampToValueAtTime(double value, double time);
}

extension type _Oscillator._(JSObject _) implements JSObject {
  external _Param get frequency;
  external JSObject connect(JSObject node);
  external void start(double when);
  external void stop(double when);
}

extension type _Gain._(JSObject _) implements JSObject {
  external _Param get gain;
  external JSObject connect(JSObject node);
}

// Tuning knobs for the "tuk": pitch drop, loudness and length.
const double _startHz = 320;
const double _endHz = 110;
const double _volume = 0.06;
const double _seconds = 0.06;

_AudioContext? _context;

/// A short, quiet "tuk": a sine dropping in pitch as it fades out. The
/// context is created on the first tap, which browsers require for audio.
void playTapSound() {
  try {
    final context = _context ??= _AudioContext();
    final now = context.currentTime;
    final tone = context.createOscillator();
    final level = context.createGain();
    tone.frequency
      ..setValueAtTime(_startHz, now)
      ..exponentialRampToValueAtTime(_endHz, now + _seconds * 0.7);
    level.gain
      ..setValueAtTime(_volume, now)
      ..exponentialRampToValueAtTime(0.0001, now + _seconds);
    tone.connect(level);
    level.connect(context.destination);
    tone
      ..start(now)
      ..stop(now + _seconds + 0.01);
  } on Object {
    // No Web Audio, or the browser blocked it: stay silent.
  }
}
