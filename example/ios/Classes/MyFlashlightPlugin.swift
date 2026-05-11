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
    if (call.method == "toggleFlashlight") {
      guard let args = call.arguments as? [String: Any],
            let isEnabled = args["isEnabled"] as? Bool else {
        result(FlutterError(code: "INVALID_ARGS", message: "Arguments are missing", details: nil))
        return
      }
      
      toggleFlash(on: isEnabled)
      result(nil)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func toggleFlash(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
    do {
      try device.lockForConfiguration()
      device.torchMode = on ? .on : .off
      device.unlockForConfiguration()
    } catch {
      print("Flashlight could not be used")
    }
  }
}