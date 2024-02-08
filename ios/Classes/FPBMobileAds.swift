//
//  FPBMobileAds.swift
//  bilmobileadsflutter
//
//  Created by HNL_MAC on 12/28/20.
//

import Flutter
import BilMobileAds

public class FPBMobileAds: NSObject, FlutterPlugin {
    
    public static let shared = FPBMobileAds()
    var isPluginInit: Bool = false;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let defaultChannel = FlutterMethodChannel(name: Utils.PBM, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(FPBMobileAds.shared, channel: defaultChannel)
        
        registrar.register(BilBannerFactory(messeneger: registrar.messenger()), withId: Utils.BANNER)
    }
    
    func isPluginReady() -> Bool {
        if (!isPluginInit){
            print("\(Utils.LOGTAG) -> PBMobileAds uninitialized, please call PBMobileAds.initialize() first.");
        }
        return isPluginInit;
    }
    
    func getUIViewController() -> UIViewController {
        return  (UIApplication.shared.keyWindow?.rootViewController)!
        //       return (UIApplication.shared.delegate?.window??.rootViewController)!;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (isPluginInit) {
            print("\(Utils.LOGTAG) -> Call - Func:\(call.method) | args:\(String(describing: call.arguments != nil ? call.arguments : "")) ");
        }
        switch call.method {
        case "initialize":
            if (isPluginInit) { return }
            
            let testMode = call.arguments as! Bool
            PBMobileAds.shared.initialize(testMode: testMode)
            isPluginInit = true
            break
        case "enableCOPPA":
            if (!isPluginReady()) {return}
            
            PBMobileAds.shared.enableCOPPA()
            break
        case "disableCOPPA":
            if (!isPluginReady()) {return}
            
            PBMobileAds.shared.disableCOPPA()
            break
        case "setYearOfBirth":
            if (!isPluginReady()) {return}
            
            let yob = call.arguments as! Int
            PBMobileAds.shared.setYearOfBirth(yob: yob)
            break
        case "setGender":
            if (!isPluginReady()) {return}
            
            let gender = call.arguments as! Int
            switch (gender) {
            case 0: // Unknown
                PBMobileAds.shared.setGender(gender: .unknown)
                break
            case 1: // Male
                PBMobileAds.shared.setGender(gender: .male)
                break
            case 2: // Female
                PBMobileAds.shared.setGender(gender: .female)
                break
            default:
                PBMobileAds.shared.setGender(gender: .unknown)
            }
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
