package com.bil.bilmobileads.flutter.bilmobileadsflutter;

import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BilBannerFactory extends PlatformViewFactory {

    FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    /**
     * @param createArgsCodec      the codec used to decode the args parameter of {@link #create}.
     * @param flutterPluginBinding
     */
    public BilBannerFactory(MessageCodec<Object> createArgsCodec, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        super(createArgsCodec);
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new FADBanner(context, this.flutterPluginBinding.getBinaryMessenger(), viewId, args);
    }
}
