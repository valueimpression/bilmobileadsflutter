package com.bil.bilmobileads.flutter.bilmobileadsflutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.StandardMessageCodec;

/** BilmobileadsflutterPlugin */
public class BilmobileadsflutterPlugin implements FlutterPlugin, ActivityAware {

    FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        FPBMobileAds.instance.register(flutterPluginBinding, binding.getActivity());
        FADInterstitial.instance.register(flutterPluginBinding);
        FADRewarded.instance.register(flutterPluginBinding);

        flutterPluginBinding.getPlatformViewRegistry()
                .registerViewFactory(Utils.BANNER, new BilBannerFactory(StandardMessageCodec.INSTANCE, flutterPluginBinding));
    }

    @Override
    public void onDetachedFromActivity() {
        FPBMobileAds.instance.dispose();
        FADInterstitial.instance.dispose();
        FADRewarded.instance.dispose();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }
}
