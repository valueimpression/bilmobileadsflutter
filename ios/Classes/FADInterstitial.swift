//
//  FADInterstitial.swift
//  bilmobileadsflutter
//
//  Created by HNL_MAC on 12/28/20.
//

import Flutter
import BilMobileAds

public class FADInterstitial: NSObject, FlutterPlugin {
    
    fileprivate var allAds: [Int: ADInterstitial] = [:]
    fileprivate var adDelegates: [Int: FADIntersitialDelegate] = [:]
    fileprivate var pluginRegistrar: FlutterPluginRegistrar?
    
    fileprivate var adUnitId: String?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = FADInterstitial()
        instance.pluginRegistrar = registrar
        let channel = FlutterMethodChannel(name: Utils.INTERSTITIAL, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func isPluginReady(id: Int, callMethod: String) -> ADInterstitial? {
        guard let adObj: ADInterstitial = allAds[id] else {
            if callMethod != "create" {
                print("\(Utils.LOGTAG) -> ADInterstitial \(id) is nil. You need init ADInterstitial first.")
                return nil
            }
            return nil
        }
        return adObj
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "create" && !FPBMobileAds.shared.isPluginReady()) { return }
        
        guard let args = call.arguments as? [String : Any]  else {
            result(FlutterError(code: "Missing args!", message: "Unable to convert args to [String : Any]", details: nil))
            return
        }
        
        let id = args["id"] as! Int
        let interstitial = self.isPluginReady(id: id, callMethod: call.method);
        if interstitial != nil {
            print("\(Utils.LOGTAG) -> Call - Func: \(call.method) | args: \(String(describing: call.arguments != nil ? call.arguments : "")) ");
        }
        switch call.method {
        case "setListener":
            if interstitial == nil { return }

            let channel = FlutterMethodChannel(name: "\(Utils.INTERSTITIAL)_\(id)", binaryMessenger: pluginRegistrar!.messenger())
            let adDelegate = FADIntersitialDelegate(channel: channel)
            interstitial!.setListener(adDelegate)
            adDelegates[id] = adDelegate
            break
        case "create":
            if (interstitial == nil) {
                let adUnitId = args["adUnitId"] as! String
                let adInterstitial = ADInterstitial(FPBMobileAds.shared.getUIViewController(), placement: adUnitId)
                allAds[id] = adInterstitial
            }
            result(nil)
            break
        case "preLoad":
            if interstitial == nil { return }
            interstitial!.preLoad()
            break
        case "show":
            if interstitial == nil { return }
            interstitial!.show()
            break
        case "isReady":
            if interstitial == nil { return }
            result(interstitial!.isReady())
            break
        case "destroy":
            if interstitial == nil { return }
            
            interstitial?.destroy()
            allAds.removeValue(forKey: id)
            adDelegates.removeValue(forKey: id)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

class FADIntersitialDelegate: NSObject, ADInterstitialDelegate {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func interstitialDidReceiveAd() {
        channel.invokeMethod("loaded", arguments: nil)
    }
    
    func interstitialLoadFail(error: String) {
        channel.invokeMethod("failedToLoad", arguments: error)
    }
    
    func interstitialWillPresentScreen() {
        channel.invokeMethod("opened", arguments: nil)
    }
    
    func interstitialDidFailToPresentScreen() {
        channel.invokeMethod("failedToShow", arguments: nil)
    }
    
    func interstitialWillDismissScreen() {}
    
    func interstitialDidDismissScreen() {
        channel.invokeMethod("closed", arguments: nil)
    }
    
    func interstitialWillLeaveApplication() {
        channel.invokeMethod("clicked", arguments: nil)
        channel.invokeMethod("leftApplication", arguments: nil)
    }
}
