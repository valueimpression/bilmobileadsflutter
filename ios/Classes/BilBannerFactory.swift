//
//  BilBannerFactory.swift
//  bilmobileadsflutter
//
//  Created by HNL_MAC on 12/28/20.
//
import Flutter

class BilBannerFactory : NSObject, FlutterPlatformViewFactory {
    let messeneger: FlutterBinaryMessenger

    init(messeneger: FlutterBinaryMessenger) {
        self.messeneger = messeneger
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return FADBanner(
            frame: frame,
            viewId: viewId,
            args: args as? [String : Any] ?? [:],
            messeneger: messeneger
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
