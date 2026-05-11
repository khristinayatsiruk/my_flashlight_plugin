import 'package:flutter/services.dart';
import 'dart:io';

class MyFlashlightPlugin {
  static const MethodChannel _channel = MethodChannel('my_flashlight_plugin');

  static Future<void> toggle(bool isEnabled) async {
    // Оновлена перевірка: дозволяємо Android ТА iOS
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw PlatformException(
        code: 'NOT_SUPPORTED',
        message: 'Цей функціонал підтримується лише на Android та iOS',
      );
    }

    // Викликаємо нативний метод
    try {
      await _channel.invokeMethod('toggleFlashlight', {'isEnabled': isEnabled});
    } on PlatformException catch (e) {
      print("Помилка плагіна: ${e.message}");
      rethrow;
    }
  }
}
