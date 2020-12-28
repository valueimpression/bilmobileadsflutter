package com.bil.bilmobileads.flutter.bilmobileadsflutter;

import android.util.Log;

import com.bil.bilmobileads.ADInterstitial;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FADInterstitial implements MethodChannel.MethodCallHandler {

    public static final FADInterstitial instance = new FADInterstitial();

    private FlutterPlugin.FlutterPluginBinding binding;
    private MethodChannel channel;

    private Map<Integer, ADInterstitial> allAds;
    private Map<Integer, MethodChannel> allAdsDelegate;

    public void register(FlutterPlugin.FlutterPluginBinding pluginBinding) {
        channel = new MethodChannel(pluginBinding.getBinaryMessenger(), Utils.INTERSTITIAL);
        channel.setMethodCallHandler(this);

        allAds = new HashMap<>();
        allAdsDelegate = new HashMap<>();

        binding = pluginBinding;
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
        channel = null;
        binding = null;
        allAds.clear();
        allAds = null;
        allAdsDelegate.clear();
        allAdsDelegate = null;
    }

    public ADInterstitial isPluginReady(int id, String callMethod) {
        ADInterstitial adObj = allAds.get(id);
        if (adObj == null) {
            if (!callMethod.equals("create"))
                Log.d(Utils.LOGTAG, "ADInterstitial " + id + " is null. You need init ADInterstitial first.");
            return null;
        }
        return adObj;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("create") && !FPBMobileAds.instance.isPluginReady()) return;

        int id = call.argument("id");
        ADInterstitial interstitial = isPluginReady(id, call.method);

        if (interstitial != null)
            Log.d(Utils.LOGTAG, "Call - Func: " + call.method + (call.arguments != null ? " | args: " + call.arguments : ""));
        switch (call.method) {
            case "setListener":
                if (interstitial == null) result.error(null, null, null);

                if (interstitial.adDelegate != null) return;

                MethodChannel adChannel = new MethodChannel(binding.getBinaryMessenger(), Utils.INTERSTITIAL + "_" + id);
                allAdsDelegate.put(id, adChannel);
                interstitial.setListener(Utils.createAdListener(adChannel));

                result.success(null);
                break;
            case "create":
                if (interstitial == null) {
                    String adUnitId = (String) call.argument("adUnitId");
                    ADInterstitial adinterstitial = new ADInterstitial(adUnitId);
                    allAds.put(id, adinterstitial);
                }

                result.success(null);
                break;
            case "preLoad":
                if (interstitial == null) result.error(null, null, null);
                interstitial.preLoad();

                break;
            case "show":
                if (interstitial == null) result.error(null, null, null);
                interstitial.show();

                break;
            case "isReady":
                if (interstitial == null) result.error(null, null, null);

                if (interstitial.isReady()) result.success(true);
                else result.success(false);

                break;
            case "destroy":
                if (interstitial == null) result.error(null, null, null);

                interstitial.destroy();
                allAds.remove(id);
                if (allAdsDelegate.get(id) != null) allAdsDelegate.remove(id);

                break;
            default:
                Log.d(Utils.LOGTAG, "Ignoring invoke from native. This normally shouldn\'t happen.");
                result.notImplemented();
                break;
        }
    }
}
