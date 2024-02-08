package com.bil.bilmobileads.flutter.bilmobileadsflutter;

import android.content.res.Resources;
import android.util.DisplayMetrics;
import android.view.Gravity;

import com.bil.bilmobileads.entity.ADRewardItem;
import com.bil.bilmobileads.entity.AdData;
import com.bil.bilmobileads.interfaces.AdDelegate;
import com.bil.bilmobileads.interfaces.AdRewardedDelegate;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

/**
 * Utilities for the Google Mobile Ads Unity plugin.
 */
public class Utils {

    public static final String LOGTAG = "FPBMobileAds";

    public static final String PBM = "bilmobileads/PBMobileAds";
    public static final String BANNER = "bilmobileads/AdBanner";
    public static final String INTERSTITIAL = "bilmobileads/AdInterstitial";
    public static final String REWARDED = "bilmobileads/AdRewarded";

    static AdDelegate createAdListener(final MethodChannel adChannel) {
        return new AdDelegate() {
            @Override
            public void onAdLoaded() {
                adChannel.invokeMethod("loaded", null);
            }

            @Override
            public void onAdOpened() {
                adChannel.invokeMethod("opened", null);
            }

            @Override
            public void onAdClosed() {
                adChannel.invokeMethod("closed", null);
            }

            @Override
            public void onAdClicked() {
                adChannel.invokeMethod("clicked", null);
            }

            @Override
            public void onAdLeftApplication() {
                adChannel.invokeMethod("leftApplication", null);
            }

            @Override
            public void onAdFailedToLoad(final String errorCode) {
                adChannel.invokeMethod("failedToLoad", errorCode);
            }
        };
    }

    static AdRewardedDelegate createAdRewardedListener(final MethodChannel adChannel) {
        return new AdRewardedDelegate() {
            @Override
            public void onRewardedAdLoaded() {
                adChannel.invokeMethod("loaded", null);
            }

            @Override
            public void onRewardedAdOpened() {
                adChannel.invokeMethod("opened", null);
            }

            @Override
            public void onRewardedAdClosed() {
                adChannel.invokeMethod("closed", null);
            }

            @Override
            public void onUserEarnedReward() {
                super.onUserEarnedReward();
                adChannel.invokeMethod("rewarded", null);
            }

            @Override
            public void onRewardedAdPaidEvent(AdData adData) {
                super.onRewardedAdPaidEvent(adData);
                Map<String, Object> args = new HashMap<>();
                args.put("currencyCode", adData.getCurrencyCode());
                args.put("microsValue", adData.getMicrosValue());
                args.put("precision", adData.getPrecision());
                adChannel.invokeMethod("rewarded", args);
            }

            @Override
            public void onRewardedAdFailedToLoad(String errorMess) {
                adChannel.invokeMethod("failedToLoad", errorMess);
            }

            @Override
            public void onRewardedAdFailedToShow(String errorMess) {
                adChannel.invokeMethod("failedToShow", errorMess);
            }
        };
    }
}
