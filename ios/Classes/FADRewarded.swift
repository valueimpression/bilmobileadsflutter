//
//  FADRewarded.swift
//  bilmobileadsflutter
//
//  Created by HNL_MAC on 12/28/20.
//

import Flutter
import BilMobileAds

public class FADRewarded: NSObject, FlutterPlugin {
    
    fileprivate var allAds: [Int: ADRewarded] = [:]
    fileprivate var adDelegates: [Int: FADRewardedDelegate] = [:]
    fileprivate var pluginRegistrar: FlutterPluginRegistrar?
    
    fileprivate var adUnitId: String?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = FADRewarded()
        instance.pluginRegistrar = registrar
        let channel = FlutterMethodChannel(name: Utils.REWARDED, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func isPluginReady(id: Int, callMethod: String) -> ADRewarded? {
        guard let adObj: ADRewarded = allAds[id] else {
            if callMethod != "create" {
                print("\(Utils.LOGTAG) -> ADRewarded \(id) is nil. You need init ADRewarded first.")
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
        let rewarded = self.isPluginReady(id: id, callMethod: call.method);
        if rewarded != nil {
            print("\(Utils.LOGTAG) -> Call - Func: \(call.method) | args: \(String(describing: call.arguments != nil ? call.arguments : "")) ");
        }
        switch call.method {
        case "setListener":
            if rewarded == nil { return }
            
            let channel = FlutterMethodChannel(name: "\(Utils.REWARDED)_\(id)", binaryMessenger: pluginRegistrar!.messenger())
            let adDelegate = FADRewardedDelegate(channel: channel)
            rewarded!.setListener(adDelegate)
            adDelegates[id] = adDelegate
            break
        case "create":
            if (rewarded == nil) {
                let adUnitId = args["adUnitId"] as! String
                let viewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!;
                let rewarded = ADRewarded(viewController, placement: adUnitId)
                allAds[id] = rewarded
            }
            result(nil)
            break
        case "preLoad":
            if rewarded == nil { return }
            rewarded!.preLoad()
            break
        case "show":
            if rewarded == nil { return }
            rewarded!.show()
            break
        case "isReady":
            if rewarded == nil { return }
            result(rewarded!.isReady())
            break
        case "destroy":
            if rewarded == nil { return }
            
            rewarded?.destroy()
            allAds.removeValue(forKey: id)
            adDelegates.removeValue(forKey: id)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

class FADRewardedDelegate: NSObject, ADRewardedDelegate {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func rewardedDidReceiveAd() {
        channel.invokeMethod("loaded", arguments: nil)
    }
    
    func rewardedDidPresent() {
        channel.invokeMethod("opened", arguments: nil)
    }
    
    func rewardedDidDismiss() {
        channel.invokeMethod("closed", arguments: nil)
    }
    
    func rewardedUserDidEarn(rewardedItem: ADRewardedItem) {
        channel.invokeMethod("rewarded", arguments: [
            "type": rewardedItem.getType(),
            "amount": rewardedItem.getAmount()
        ])
    }
    
    func rewardedFailedToLoad(error: String) {
        channel.invokeMethod("failedToLoad", arguments: error)
    }
    
    func rewardedFailedToPresent(error: String) {
        channel.invokeMethod("failedToShow", arguments: error)
    }
    
}
