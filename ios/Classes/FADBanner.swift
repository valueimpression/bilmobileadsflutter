//
//  FADBanner.swift
//  bilmobileadsflutter
//
//  Created by HNL_MAC on 12/28/20.
//

import Flutter
import BilMobileAds

class FADBanner : NSObject, FlutterPlatformView, ADBannerDelegate {
    
    private var channel: FlutterMethodChannel!
    private var banner: ADBanner!
    
    private var adPlaceholder: UIView!
    
    /**
     * A boolean indicating whether the ad has been hidden.
     * true -> ad is off, false -> ad is on screen.
     */
    private var isHidden: Bool!
        
    init(frame: CGRect, viewId: Int64, args: [String: Any], messeneger: FlutterBinaryMessenger) {
        super.init()
        if (!FPBMobileAds.shared.isPluginReady()) { return }

        self.adPlaceholder = UIView(frame: frame)
        
        let adUnitId = args["adUnitId"] as? String
        self.banner = ADBanner(FPBMobileAds.shared.getUIViewController(), view: self.adPlaceholder, placement: adUnitId!)
        self.isHidden = false
        
        self.channel = FlutterMethodChannel(name: "\(Utils.BANNER)_\(viewId)", binaryMessenger: messeneger)
        self.channel.setMethodCallHandler{ [weak self] (call: FlutterMethodCall, result: FlutterResult) in
            switch call.method {
            case "setListener":
                self?.banner.setListener(self!)
                break
            case "show":
                if (self?.isHidden == false) { return }
                
                self?.isHidden = false
                self?.banner.getADView().isHidden = false
                self?.banner.startFetchData()
                break
            case "hide":
                if (self?.isHidden == true) { return }
                
                self?.isHidden = true;
                self?.banner.getADView().isHidden = true
                self?.banner.stopFetchData();
                break
            case "widthInPixels":
                result(self?.banner!.getWidthInPixels())
                break
            case "heightInPixels":
                result(self?.banner!.getHeightInPixels())
                break
            case "destroy":
                self?.dispose()
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func view() -> UIView {
        return self.adPlaceholder
    }
    
    private func dispose() {
        banner.destroy()
        channel.setMethodCallHandler(nil)
    }
    
    func bannerDidReceiveAd() {
        channel.invokeMethod("loaded", arguments: nil)
    }
    
    func bannerWillPresentScreen() {
        channel.invokeMethod("opened", arguments: nil)
    }
    
    func bannerDidDismissScreen() {
        channel.invokeMethod("closed", arguments: nil)
    }
    
    func bannerWillLeaveApplication() {
        channel.invokeMethod("clicked", arguments: nil)
        channel.invokeMethod("leftApplication", arguments: nil)
    }
    
    func bannerLoadFail(error: String) {
        channel.invokeMethod("failedToLoad", arguments: error)
    }
    
    func bannerWillDismissScreen() {}
}
