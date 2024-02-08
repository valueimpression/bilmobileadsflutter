package com.bil.bilmobileads.flutter.bilmobileadsflutter;

import android.util.Log;

import com.bil.bilmobileads.ADRewarded;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FADRewarded implements MethodChannel.MethodCallHandler {

    public static final FADRewarded instance = new FADRewarded();

    private FlutterPlugin.FlutterPluginBinding binding;
    private MethodChannel channel;

    private Map<Integer, ADRewarded> allAds;
    private Map<Integer, MethodChannel> allAdsDelegate;

    public void register(FlutterPlugin.FlutterPluginBinding pluginBinding) {
        channel = new MethodChannel(pluginBinding.getBinaryMessenger(), Utils.REWARDED);
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

    public ADRewarded isPluginReady(int id, String callMethod) {
        ADRewarded adObj = allAds.get(id);
        if (adObj == null) {
            if (!callMethod.equals("create"))
                Log.d(Utils.LOGTAG, "ADRewarded " + id + " is null. You need init ADRewarded first.");
            return null;
        }
        return adObj;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("create") && !FPBMobileAds.instance.isPluginReady()) return;

        int id = call.argument("id");
        ADRewarded rewarded = isPluginReady(id, call.method);

        if (rewarded != null)
            Log.d(Utils.LOGTAG, "Call - Func: " + call.method + (call.arguments != null ? " | args: " + call.arguments : ""));
        switch (call.method) {
            case "setListener":
                if (rewarded == null) result.error(null, null, null);

                MethodChannel adChannel = new MethodChannel(binding.getBinaryMessenger(), Utils.REWARDED + "_" + id);
                allAdsDelegate.put(id, adChannel);
                rewarded.setListener(Utils.createAdRewardedListener(adChannel));

                result.success(null);
                break;
            case "create":
                if (rewarded == null) {
                    String adUnitId = (String) call.argument("adUnitId");
                    ADRewarded adRewarded = new ADRewarded(FPBMobileAds.instance.getFlutterActivity(),
                            adUnitId);
                    allAds.put(id, adRewarded);
                }

                result.success(null);
                break;
            case "preLoad":
                if (rewarded == null) result.error(null, null, null);
                rewarded.preLoad();

                break;
            case "show":
                if (rewarded == null) result.error(null, null, null);
                rewarded.show();

                break;
            case "isReady":
                if (rewarded == null) result.error(null, null, null);

                if (rewarded.isReady()) result.success(true);
                else result.success(false);

                break;
            case "destroy":
                if (rewarded == null) result.error(null, null, null);

                rewarded.destroy();
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