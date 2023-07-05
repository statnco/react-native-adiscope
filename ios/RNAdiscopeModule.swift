//
//  RNAdiscopeModule.swift
//  RNAdiscopeModule
//
//  Created by KIKI on 2023/06/28.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import Adiscope

@objc (RNAdiscopeModule)
class RNAdiscopeModule: RCTEventEmitter {
    var hasListeners = false
    var adiscope = AdiscopeInterface.sharedInstance()!

    override func startObserving() {
        hasListeners = true
    }

    override func stopObserving() {
        hasListeners = false
    }

    override func supportedEvents() -> [String]? {
        return [
            "onInitialized",
            "onOfferwallAdOpened",
            "onOfferwallAdClosed",
            "onOfferwallAdFailedToShow",
            "onRewardedVideoAdOpened",
            "onRewardedVideoAdClosed",
            "onRewarded",
            "onRewardedVideoAdFailedToLoad",
            "onRewardedVideoAdFailedToShow",
            "onInterstitialAdOpened",
            "onInterstitialAdClosed",
            "onInterstitialAdFailedToLoad",
            "onInterstitialAdFailedToShow"
        ]
    }

    @objc(initialize:mediaSecret:)
        func initialize(_ mediaId: String, mediaSecret: String) -> Void {
            adiscope.setMainDelegate(self)
            adiscope.initialize(mediaId, mediaSecret: mediaSecret, callBackTag: nil)
        }

    @objc
        func onInitialized(_ isSuccess: Bool) {
            print("onInitialized", isSuccess)
            sendEvent(withName: "onInitialized", body: ["initialized": isSuccess])
        }

    @objc(setUserId:resolver:rejecter:)
        func setUserId(_ userId: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock ) -> Void {
            if adiscope.setUserId(userId) {
                resolve(userId)
            } else {
                reject("E_FAILED_TO_SET_USER_ID", "setUserId failure", nil)
            }
        }

    @objc(isRVLoaded:Callback:)
    func isRVLoaded(_ unitId: String, Callback callback: RCTResponseSenderBlock ) -> Void {
        print("isRVLoaded", unitId)
        adiscope.isLoaded(unitId)
    }

    // << Rewarded Video >>
    @objc(showRewardedVideo:)
    func showRewardedVideo(_ rewardedVideoUnitID: String) -> Void {
        print("rewarded video unit id", rewardedVideoUnitID)
        adiscope.load(rewardedVideoUnitID)
    }

    @objc
    func onRewardedVideoAdLoaded(_ unitID: String) -> Void {
        print("onRewardedVideoAdLoaded")
        adiscope.show()
    }

    @objc
    func onRewardedVideoAdFailedToLoad(_ unitID: String, Error error: AdiscopeError) -> Void {
        print("onRewardedVideoAdFailedToLoad", error)
        sendEvent(withName: "onRewardedVideoAdFailedToLoad", body: ["opened": false, "error": error])
    }

    @objc
    func onRewardedVideoAdOpened(_ unitID: String) -> Void {
        print("onRewardedVideoAdOpened")
        sendEvent(withName: "onRewardedVideoAdOpened", body: ["opened": true])
    }

    @objc
    func onRewardedVideoAdClosed(_ unitID: String) -> Void {
        print("onRewardedVideoAdClosed")
        sendEvent(withName: "onRewardedVideoAdClosed", body: ["opened": false])
    }

    @objc
    func onRewardedVideoAdFailedToShow(_ unitID: String, Error error: AdiscopeError) -> Void {
        print("onRewardedVideoAdFailedToShow", error)
        sendEvent(withName: "onRewardedVideoAdFailedToShow", body: ["opened": false, "error": error])
    }

    @objc
    func onRewarded(_ unitID: String, Rewarded rewarded: AdiscopeRewardItem) -> Void {
        print("onRewarded", rewarded)
        sendEvent(withName: "onRewarded", body: ["opened": true, "rewarded": rewarded])
    }

    // << Interstitial >>
    @objc(showInterstitial:)
        func showInterstitial(_ interstitialUnitID: String) -> Void {
            print("interstitial unit id", interstitialUnitID)
            adiscope.loadInterstitial(interstitialUnitID)
        }

    @objc
        func onInterstitialAdLoaded(_ unitID: String) -> Void {
            print("onInterstitialAdLoaded")
            adiscope.showInterstitial()
        }

    @objc
        func onInterstitialAdFailedToLoad(_ unitId: String, Error error : AdiscopeError) -> Void {
            print("onInterstitialAdFailedToLoad", error)
            sendEvent(withName: "onInterstitialAdFailedToLoad", body: ["opened": false, "error": error])
        }

    @objc
        func onInterstitialAdFailedToShow(_ unitId: String, Error error : AdiscopeError) -> Void {
            print("onInterstitialAdFailedToShow", error)
            sendEvent(withName: "onInterstitialAdFailedToShow", body: ["opened": false, "error": error])
        }

    @objc
        func onInterstitialAdOpened(_ unitId: String) -> Void {
            print("onInterstitialAdOpened")
            sendEvent(withName: "onInterstitialAdOpened", body: ["opened": true])
        }

    @objc
        func onInterstitialAdClosed(_ unitId: String) -> Void {
            print("onInterstitialAdClosed")
            sendEvent(withName: "onInterstitialAdClosed", body: ["opened": false])
        }

    // << Offerwall >>
    @objc(showOfferwall:)
        func showOfferwall(_ offerwallUnitID: String) -> Void {
            print("interstitial unit id", offerwallUnitID)
            adiscope.showOfferwall(offerwallUnitID)
        }

    @objc
        func onOfferwallAdOpened(_ unitID: String) -> Void {
            print("onOfferwallAdOpened")
            sendEvent(withName: "onOfferwallAdOpened", body: ["opened": true])
        }

    @objc
        func onOfferwallAdClosed(_ unitID: String) -> Void {
            print("onOfferwallAdClosed")
            sendEvent(withName: "onOfferwallAdClosed", body: ["opened": false])
        }

    @objc
        func onOfferwallAdFailedToShow(_ unitID: String, error: AdiscopeError) -> Void {
            print("onOfferwallAdFailedToShow")
            sendEvent(withName: "onOfferwallAdFailedToShow", body: ["opened": false, "error": error])
        }
}
