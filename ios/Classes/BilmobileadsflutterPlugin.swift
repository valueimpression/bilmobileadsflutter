import Flutter
import UIKit

public class BilmobileadsflutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bilmobileadsflutter", binaryMessenger: registrar.messenger())
    let instance = BilmobileadsflutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
      
    FPBMobileAds.register(with: registrar)
    FADInterstitial.register(with: registrar)
    FADRewarded.register(with: registrar)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
