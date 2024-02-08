package com.bil.bilmobileads.flutter.bilmobileadsflutter;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;

import com.bil.bilmobileads.ADBanner;

import java.util.HashMap;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class FADBanner implements PlatformView, MethodChannel.MethodCallHandler {

    private MethodChannel channel;
    private ADBanner banner;
    private int id;

    /**
     * A boolean indicating whether the ad has been hidden.
     * true -> ad is off, false -> ad is on screen.
     */
    private boolean isHidden;

    /**
     * The {@link FrameLayout} to display ad.
     */
    private FrameLayout adPlaceholder;

    FADBanner(Context context, BinaryMessenger messenger, int id, Object argsObj) {
        if (!FPBMobileAds.instance.isPluginReady()) return;

        this.id = id;
        channel = new MethodChannel(messenger, Utils.BANNER + "_" + id);
        channel.setMethodCallHandler(this);

        // Create a RelativeLayout and add the ad view to it
        this.adPlaceholder = new FrameLayout(FPBMobileAds.instance.getFlutterActivity());
        this.adPlaceholder.setBackgroundColor(Color.TRANSPARENT);
        this.adPlaceholder.setVisibility(View.VISIBLE);

        HashMap<String, Object> args = (HashMap<String, Object>) argsObj;
        String adUnitId = (String) args.get("adUnitId");
        banner = new ADBanner(FPBMobileAds.instance.getFlutterActivity(), this.adPlaceholder, adUnitId);
        this.isHidden = false;
    }

    public boolean isPluginReady() {
        if (banner == null) {
            Log.d(Utils.LOGTAG, "ADBanner is null. You need init ADBanner first.");
            return false;
        }
        return true;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (!isPluginReady()) {
            result.error(null, null, null);
            return;
        }

        Log.d(Utils.LOGTAG, "Call - Func: " + call.method + (call.arguments != null ? " | args: " + call.arguments : ""));
        switch (call.method) {
            case "setListener":
                banner.setListener(Utils.createAdListener(channel));
                result.success(null);
                break;
            case "show":
                if (!this.isHidden) return;

                Log.d(Utils.LOGTAG, "Calling show() AdBanner_" + id);
                isHidden = false;
                banner.startFetchData();
                adPlaceholder.setVisibility(View.VISIBLE);

                break;
            case "hide":
                if (this.isHidden) return;

                Log.d(Utils.LOGTAG, "Calling hide() ADBanner_" + id);
                isHidden = true;
                banner.stopFetchData();
                adPlaceholder.setVisibility(View.GONE);

                break;
            case "widthInPixels":
                if (banner == null) result.error(null, null, null);

                if (banner.isLoaded()) result.success((double) banner.getWidthInPixels());
                else result.success(0.0);

                break;
            case "heightInPixels":
                if (banner == null) result.error(null, null, null);

                if (banner.isLoaded()) result.success((double) banner.getHeightInPixels());
                else result.success(0.0);

                break;
            case "destroy":
                this.dispose();
                break;
            default:
                Log.d(Utils.LOGTAG, "Ignoring invoke from native. This normally shouldn\'t happen.");
                result.notImplemented();
                break;
        }
    }

    @Override
    public View getView() {
        return this.adPlaceholder;
    }

    @Override
    public void dispose() {
        channel.setMethodCallHandler(null);

        adPlaceholder.removeAllViews();
        adPlaceholder.setVisibility(View.GONE);
        adPlaceholder = null;

        banner.destroy();
        banner = null;
    }
}
