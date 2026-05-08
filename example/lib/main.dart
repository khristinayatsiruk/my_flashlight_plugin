import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _statusMessage = 'Натисніть кнопку, щоб перевірити ліхтарик';

  // Метод для перемикання ліхтарика
  Future<void> _toggleFlashlight(bool isEnabled) async {
    try {
      // Викликаємо статичний метод нашого плагіна
      await MyFlashlightPlugin.toggle(isEnabled);
      setState(() {
        _statusMessage = isEnabled ? 'Ліхтарик увімкнено' : 'Ліхтарик вимкнено';
      });
    } on PlatformException catch (e) {
      // Оскільки ти на Mac/iOS, спрацює цей блок
      setState(() {
        _statusMessage = "Помилка: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flashlight Plugin Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _toggleFlashlight(true),
                  child: const Text('Увімкнути (Тільки Android)'),
                ),
                ElevatedButton(
                  onPressed: () => _toggleFlashlight(false),
                  child: const Text('Вимкнути'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
