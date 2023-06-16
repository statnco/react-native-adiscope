package com.statnco.reactnativeadiscope;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import com.nps.adiscope.AdiscopeError;
import com.nps.adiscope.AdiscopeSdk;
import com.nps.adiscope.core.Adiscope;
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

    private static ReactContext mContext;

    private static OfferwallAd mOfferwallAd;
    private static RewardedVideoAd mRewardedVideoAd;
    private static InterstitialAd mInterstitialAd;

    public RNAdiscopeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
        initialize();
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    public static void sendEvent(String eventName, @Nullable WritableMap data) {
        WritableMap params = Arguments.createMap();
        params.putMap("data", data);
        mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    public void initialize() {
        if(!mContext.hasActiveCatalystInstance()) {
            return;
        }
        AdiscopeSdk.initialize(getCurrentActivity(), new AdiscopeInitializeListener() {
            @Override
            public void onInitialized(boolean isSuccess) {
                if (isSuccess) {
                    mRewardedVideoAd = AdiscopeSdk.getRewardedVideoAdInstance(getCurrentActivity());
                    mRewardedVideoAd.setRewardedVideoAdListener(mRewardedVideoAdListener());
                    mInterstitialAd = AdiscopeSdk.getInterstitialAdInstance(getCurrentActivity());
                    mInterstitialAd.setInterstitialAdListener(mInterstitialAdListener());
                    mOfferwallAd = AdiscopeSdk.getOfferwallAdInstance(getCurrentActivity());
                    mOfferwallAd.setOfferwallAdListener(mOfferwallAdListener());
                    AdiscopeSdk.setUserId("androidTestId12354");
                    AdiscopeSdk.getOptionSetterInstance(getCurrentActivity()).setChildYN("NO");
                }

                WritableMap payload = Arguments.createMap();
                payload.putBoolean("onInitialized", isSuccess);
                sendEvent("onInitialized", payload);
            }
        });

    }

    public RewardedVideoAdListener mRewardedVideoAdListener() {
        return new RewardedVideoAdListener() {
            /*
             *  - Rewarded Video(RV) 광고를 받아 오면(load) 자동 호출되는 함수
             *  - 광고가 load 되었기 때문에 바로 재생(show)
            */
            @Override
            public void onRewardedVideoAdLoaded(String unitId) {
                mRewardedVideoAd.show();
            }
            /*
             *  - Rewarded Video(RV) 광고를 받아 오지 못했을 때(load fail) 자동 호출되는 함수
             *  - 유저가 광고 시청을 요청했기 때문에, Toast를 통해 load fail 상황을 안내하는 예제
            */
            @Override
            public void onRewardedVideoAdFailedToLoad(String unitId, AdiscopeError adiscopeError) {
                WritableMap payload = Arguments.createMap();
                payload.putString("error", adiscopeError.toString());
                sendEvent("onRewardedVideoAdFailedToLoad", payload);
            }

            /*
             *  - Rewarded Video(RV) 광고 화면이 open 되었을 때 자동 호출되는 함수
            */
            @Override
            public void onRewardedVideoAdOpened(String unitId) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("opened", true);
                sendEvent("onRewardedVideoAdOpened", payload);
            }
            /*
             *  - Rewarded Video(RV) 광고 시청 후 X 버튼을 클릭했을 때, 즉 유저가 광고 시청 완료했을 때
             *  Toast 통해 안내하는 예제
            */
            @Override
            public void onRewardedVideoAdClosed(String unitId) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("opened", false);
                sendEvent("onRewardedVideoAdClosed", payload);
            }
            /*
             *  - 광고 네트워크를 통해 Rewarded Video(RV) 광고 시청 완료 메시지를 받을 때 자동 호출되는 함수
            */
            @Override
            public void onRewarded(String unitId, RewardItem rewardItem) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("rewarded", true);
                sendEvent("onRewarded", payload);
            }
            /*
             *  - Rewarded Video(RV) 광고를 받아 왔으나(load) 재생하지 못했을 때 자동 호출되는 함수
             *  - 유저가 광고를 요청했기 때문에 현재의 상태를 유저에게 Toast 안내하는 예제
            */
            @Override
            public void onRewardedVideoAdFailedToShow(String unitId, AdiscopeError adiscopeError) {
                WritableMap payload = Arguments.createMap();
                payload.putString("error", adiscopeError.toString());
                sendEvent("onRewardedVideoAdFailedToShow", payload);
            }
        };
    }

    /**
     * RewardedVideoAdListener
     */
    public InterstitialAdListener mInterstitialAdListener() {
        return new InterstitialAdListener() {
            /*
             *  - Interstitial 광고를 받아 오면(load) 자동 호출되는 함수
             *  - 광고가 load 되었기 때문에 바로 재생(show)
            */
            @Override
            public void onInterstitialAdLoaded() {
                mInterstitialAd.show();
            }
            /*
             *  - Interstitial 광고를 받아 오지 못했을 때(load fail) 자동 호출되는 함수
             *  - 유저의 요청과 상관없이 광고 요청이 되었기 때문에, load fail 상태를 유저에게 안내하지 않음
                안내하고자 한다면, Toast 등을 통해 안내 가능
            */
            @Override
            public void onInterstitialAdFailedToLoad(AdiscopeError adiscopeError) {
                WritableMap payload = Arguments.createMap();
                payload.putString("error", adiscopeError.toString());
                sendEvent("onInterstitialAdFailedToLoad", payload);
            }
            /*
             *  - Interstitial 광고 화면이 open 되었을 때 자동 호출되는 함수
            */
            @Override
            public void onInterstitialAdOpened(String unitId) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("opened", true);
                sendEvent("onInterstitialAdOpened", payload);
            }
            /*
             *  - Interstitial 광고 시청 후 X 버튼을 클릭했을 때 자동 호출되는 함수
            */
            @Override
            public void onInterstitialAdClosed(String unitId) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("opened", false);
                sendEvent("onInterstitialAdClosed", payload);
            }
            /*
             *  - Interstitial 광고를 받아 왔으나(load) 재생하지 못했을 때 자동 호출되는 함수
             *  - 유저의 의도와 상관없이 진행되기 때문에, Toast 통해 별도 안내하지 않음
            */
            @Override
            public void onInterstitialAdFailedToShow(String unitId, AdiscopeError adiscopeError) {
                WritableMap payload = Arguments.createMap();
                payload.putString("error", adiscopeError.toString());
                sendEvent("onInterstitialAdFailedToShow", payload);
            }
        };
    }


    /**
     * OfferwallAdListener
     */
    public OfferwallAdListener mOfferwallAdListener() {
        return new OfferwallAdListener() {
            // Offerwall 화면이 오픈되었을 때 자동 호출되는 함수
            @Override
            public void onOfferwallAdOpened(String s) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("opened", true);
                sendEvent("onOfferwallAdOpened", payload);
            }
            // Offerwall 화면이 오픈되지 않았을 때 자동 호출되는 함수
            @Override
            public void onOfferwallAdFailedToShow(String unitId, AdiscopeError adiscopeError) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("opened", false);
                payload.putString("error", adiscopeError.toString());
                sendEvent("onOfferwallAdFailedToShow", payload);
            }
            // Offerwall 화면을 닫았을 때 자동 호출되는 함수
            @Override
            public void onOfferwallAdClosed(String unitId) {
                WritableMap payload = Arguments.createMap();
                payload.putBoolean("opened", false);
                sendEvent("onOfferwallAdClosed", payload);
            }
        };
    }

    /*
      - Rewarded Video(RV), Interstitial, Offerwal API 요청 전에, Initialized Instance에 userId 적용
      - 앱 실행 후 한번만 적용
    */
    @ReactMethod
    public void setUserId(String userId) {
        AdiscopeSdk.setUserId(userId);
    }

    @ReactMethod
    public void showRewardedVideo(String unitId) {
        RewardedVideoAd rewardedVideoAd = Adiscope.getRewardedVideoAdInstance(getCurrentActivity());
        rewardedVideoAd.load(unitId);
    }

    @ReactMethod
    public void showOfferwall(String unitId) {
        OfferwallAd offerwallAd = Adiscope.getOfferwallAdInstance(getCurrentActivity());
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
        InterstitialAd interstitialAd = AdiscopeSdk.getInterstitialAdInstance(getCurrentActivity());
        interstitialAd.load(unitId);
    }

    @ReactMethod
    public void addListener(String eventName) {
        // Keep: Required for RN built in Event Emitter Calls.
    }
    @ReactMethod
    public void removeListeners(Integer count) {
        // Keep: Required for RN built in Event Emitter Calls.
    }
}
