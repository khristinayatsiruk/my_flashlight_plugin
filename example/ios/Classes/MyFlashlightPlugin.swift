import Flutter
import UIKit
import AVFoundation

public class MyFlashlightPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "my_flashlight_plugin", binaryMessenger: registrar.messenger())
    let instance = MyFlashlightPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "toggleFlashlight":
      // Отримуємо аргументи з Dart
      guard let args = call.arguments as? [String: Any],
            let isEnabled = args["isEnabled"] as? Bool else {
        result(FlutterError(code: "INVALID_ARGUMENTS", 
                            message: "Expected a boolean for isEnabled", 
                            details: nil))
        return
      }
      
      let success = toggleFlash(on: isEnabled)
      if success {
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE", 
                            message: "Flashlight not available or broken", 
                            details: nil))
      }
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func toggleFlash(on: Bool) -> Bool {
    // Перевіряємо наявність камери та спалаху
    guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
      return false
    }
    
    do {
      try device.lockForConfiguration()
      device.torchMode = on ? .on : .off
      device.unlockForConfiguration()
      return true
    } catch {
      return false
    }
  }
}