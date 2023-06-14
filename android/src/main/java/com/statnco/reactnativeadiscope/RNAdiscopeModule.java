package com.statnco.reactnativeadiscope;

import androidx.annotation.NonNull;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

import com.nps.adiscope.AdiscopeError;
import com.nps.adiscope.AdiscopeSdk;
import com.nps.adiscope.interstitial.InterstitialAd;
import com.nps.adiscope.interstitial.InterstitialAdListener;
import com.nps.adiscope.listener.AdiscopeInitializeListener;
import com.nps.adiscope.offerwall.OfferwallAd;
import com.nps.adiscope.offerwall.OfferwallAdListener;
import com.nps.adiscope.reward.RewardItem;
import com.nps.adiscope.reward.RewardedVideoAd;
import com.nps.adiscope.reward.RewardedVideoAdListener;

@ReactModule(name = RNAdiscopeModule.NAME)
public class RNAdiscopeModule extends ReactContextBaseJavaModule {
  public static final String NAME = "RNAdiscopeModule";
  private static final String TAG = RNAdiscopeModule.class.getName();
  private static OfferwallAd mOfferwallAd;
  private static RewardedVideoAd mRewardedVideoAd;
  private static InterstitialAd mInterstitialAd;

  private static OfferwallAdListener mOfferwallAdListener;
  private static RewardedVideoAdListener mRewardedVideoAdListener;
  private static InterstitialAdListener mInterstitialAdListener;

  public RNAdiscopeModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void initialize() {
    AdiscopeSdk.initialize(getCurrentActivity(), new AdiscopeInitializeListener() {
        @Override
        public void onInitialized(boolean isSuccess) {
            if (isSuccess) {
            // get rewardVideo singleton instance
                Log.d(RNAdiscopeModule.class.getName(), ">>> called onInitialized : isSuccess -> true");
                mRewardedVideoAd = AdiscopeSdk.getRewardedVideoAdInstance(getCurrentActivity());
                mRewardedVideoAd.setRewardedVideoAdListener(mRewardedVideoAdListener);
                mInterstitialAd = AdiscopeSdk.getInterstitialAdInstance(getCurrentActivity());
                mInterstitialAd.setInterstitialAdListener(mInterstitialAdListener);
                mOfferwallAd = AdiscopeSdk.getOfferwallAdInstance(getCurrentActivity());
                mOfferwallAd.setOfferwallAdListener(mOfferwallAdListener);
                AdiscopeSdk.setUserId("androidTestId");
            } else {
                // Init 실패 에 대한 처리 Code
                Log.d(RNAdiscopeModule.class.getName(), ">>> called onInitialized : isSuccess -> false");
            }
        }
    });
  }


  @ReactMethod
  public void showRewardedVideo(String unitId) {
    RewardedVideoAd rewardedVideoAd = AdiscopeSdk.getRewardedVideoAdInstance(getCurrentActivity());
    rewardedVideoAd.load(unitId);
  }

  @ReactMethod
  public void showOfferwall(String unitId) {
    OfferwallAd offerwallAd = AdiscopeSdk.getOfferwallAdInstance(getCurrentActivity());
    String[] excludeAdTypeList = {"CPS"};
    if (offerwallAd.show(getCurrentActivity(), unitId, new String[]{})) {
    // Succeed
    } else {
    // show is already in progress
    }
  }

  @ReactMethod
  public void showDetail(String unitId, int itemId) {
    OfferwallAd offerwallAd = AdiscopeSdk.getOfferwallAdInstance(getCurrentActivity());
    if (offerwallAd.showDetail(getCurrentActivity(), unitId, new String[]{}, itemId)) {
    // Succeed
    } else {
    // show is already in progress
    }
  }

  @ReactMethod
  public void showInterstitial(String unitId) {
    Log.d(TAG, ">>> call showInterstitial()");
    InterstitialAd interstitialAd = AdiscopeSdk.getInterstitialAdInstance(getCurrentActivity());
    interstitialAd.load(unitId);
  }
}
