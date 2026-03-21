import 'package:flutter/material.dart';
import 'package:flutter_datawedge/src/pigeon.dart';

/// Programmatic control over the KC50 LED Light Bar
class LedLightBar {
  /// Creates a new [LedLightBar] instance
  LedLightBar() : _api = LedLightBarHostApi();

  final LedLightBarHostApi _api;

  /// Default LED ID for the KC50 light bar
  static const int defaultLedId = 101;

  /// Converts a [Color] to the 0xRRGGBB integer format required by the API.
  int _colorToInt(Color color) {
    // Strip the alpha channel, keeping only RGB
    return color.value & 0xFFFFFF;
  }

  /// Sets the LED to the specified color.
  ///
  /// [color] The color to set.
  /// [ledId] The ID of the LED to control. Defaults to 101.
  Future<void> setLight(Color color, {int ledId = defaultLedId}) async {
    await _api.setLight(ledId, _colorToInt(color));
  }

  /// Turns OFF the LED.
  Future<void> setLedOff() async {
    await _api.setLedOff();
  }

  /// Sets a repeating light sequence of two alternating colors.
  ///
  /// [color1] The first color in the sequence.
  /// [period1] The length of time to illuminate [color1].
  /// [color2] The second color in the sequence.
  /// [period2] The length of time to illuminate [color2].
  /// [ledId] The ID of the LED to control. Defaults to 101.
  Future<void> setLightSequence({
    required Color color1,
    required Duration period1,
    required Color color2,
    required Duration period2,
    int ledId = defaultLedId,
  }) async {
    await _api.setLightSequence(
      ledId,
      _colorToInt(color1),
      period1.inMilliseconds,
      _colorToInt(color2),
      period2.inMilliseconds,
    );
  }

  /// Stops the light sequence and continuously displays the specified color.
  /// If color is transparent (0x000000), it will turn off the LED.
  ///
  /// [color] The color to display.
  /// [ledId] The ID of the LED to control. Defaults to 101.
  Future<void> setLedSequenceOff(
    Color color, {
    int ledId = defaultLedId,
  }) async {
    await _api.setLedSequenceOff(ledId, _colorToInt(color));
  }
}
