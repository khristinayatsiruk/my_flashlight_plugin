import 'package:flutter/services.dart';
import 'dart:io';

class MyFlashlightPlugin {
  static const MethodChannel _channel = MethodChannel('my_flashlight_plugin');

  static Future<void> toggle(bool isEnabled) async {
    // Перевірка платформи
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: 'NOT_SUPPORTED',
        message: 'Цей функціонал підтримується лише на Android',
      );
    }

    await _channel.invokeMethod('toggleFlashlight', {'isEnabled': isEnabled});
  }
}
