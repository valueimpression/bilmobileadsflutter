package com.bil.bilmobileads.flutter.bilmobileadsflutter;

import android.app.Activity;
import android.util.Log;

import com.bil.bilmobileads.PBMobileAds;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class FPBMobileAds implements MethodCallHandler {

    public static final FPBMobileAds instance = new FPBMobileAds();

    private MethodChannel channel;
    private Activity flutterActivity;
    private boolean isPluginInit;

    public void register(FlutterPlugin.FlutterPluginBinding binding, Activity activity) {
        channel = new MethodChannel(binding.getBinaryMessenger(), Utils.PBM);
        channel.setMethodCallHandler(this);

        flutterActivity = activity;
        isPluginInit = false;
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
        channel = null;

        isPluginInit = false;
    }

    boolean isPluginReady() {
        if (!isPluginInit)
            Log.d(Utils.LOGTAG, "PBMobileAds uninitialized, please call PBMobileAds.initialize() first.");
        return isPluginInit;
    }

    Activity getFlutterActivity() {
        return flutterActivity;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (isPluginInit)
            Log.d(Utils.LOGTAG, "Call - Func: " + call.method + (call.arguments != null ? " | args: " + call.arguments : ""));
        switch (call.method) {
            case "initialize":
                if (isPluginInit) return;

                final boolean testMode = (boolean) call.arguments;
                PBMobileAds.instance.initialize(flutterActivity, testMode);
                isPluginInit = true;

                result.success(null);
                break;
            case "enableCOPPA":
                if (!isPluginReady()) return;

                PBMobileAds.getInstance().enableCOPPA();
                result.success(null);
                break;
            case "disableCOPPA":
                if (!isPluginReady()) return;

                PBMobileAds.getInstance().disableCOPPA();
                result.success(null);
                break;
            case "setYearOfBirth":
                if (!isPluginReady()) return;

                int yob = (int) call.arguments;
                PBMobileAds.getInstance().setYearOfBirth(yob);
                result.success(null);
                break;
            case "setGender":
                if (!isPluginReady()) return;

                int gender = (int) call.arguments;
                switch (gender) {
                    case 0: // Unknown
                        PBMobileAds.getInstance().setGender(PBMobileAds.GENDER.UNKNOWN);
                        break;
                    case 1: // Male
                        PBMobileAds.getInstance().setGender(PBMobileAds.GENDER.MALE);
                        break;
                    case 2: // Female
                        PBMobileAds.getInstance().setGender(PBMobileAds.GENDER.FEMALE);
                        break;
                }
                result.success(null);
                break;
            default:
                Log.d(Utils.LOGTAG, "Ignoring invoke from native. This normally shouldn\'t happen.");
                result.notImplemented();
                break;
        }
    }
}
