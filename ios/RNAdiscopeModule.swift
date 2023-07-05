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
        adiscope.isLoaded(unitId)
    }

    // << Rewarded Video >>
    @objc(showRewardedVideo:)
    func showRewardedVideo(_ rewardedVideoUnitID: String) -> Void {
        adiscope.load(rewardedVideoUnitID)
    }

    @objc
    func onRewardedVideoAdLoaded(_ unitID: String) -> Void {
        adiscope.show()
    }

    @objc
    func onRewardedVideoAdFailedToLoad(_ unitID: String, Error error: AdiscopeError) -> Void {
        sendEvent(withName: "onRewardedVideoAdFailedToLoad", body: ["opened": false, "error": "\(error)"])
    }

    @objc
    func onRewardedVideoAdOpened(_ unitID: String) -> Void {
        sendEvent(withName: "onRewardedVideoAdOpened", body: ["opened": true])
    }

    @objc
    func onRewardedVideoAdClosed(_ unitID: String) -> Void {
        sendEvent(withName: "onRewardedVideoAdClosed", body: ["opened": false])
    }

    @objc
    func onRewardedVideoAdFailedToShow(_ unitID: String, Error error: AdiscopeError) -> Void {
        sendEvent(withName: "onRewardedVideoAdFailedToShow", body: ["opened": false, "error": "\(error)"])
    }

    @objc
    func onRewarded(_ unitID: String, Rewarded rewarded: AdiscopeRewardItem) -> Void {
        sendEvent(withName: "onRewarded", body: ["opened": true, "rewarded": rewarded])
    }

    // << Interstitial >>
    @objc(showInterstitial:)
    func showInterstitial(_ interstitialUnitID: String) -> Void {
        adiscope.loadInterstitial(interstitialUnitID)
    }

    @objc
    func onInterstitialAdLoaded(_ unitID: String) -> Void {
        adiscope.showInterstitial()
    }

    @objc
    func onInterstitialAdFailedToLoad(_ unitId: String, Error error : AdiscopeError) -> Void {
        sendEvent(withName: "onInterstitialAdFailedToLoad", body: ["opened": false, "error": "\(error)"])
    }

    @objc
    func onInterstitialAdFailedToShow(_ unitId: String, Error error : AdiscopeError) -> Void {
        sendEvent(withName: "onInterstitialAdFailedToShow", body: ["opened": false, "error": "\(error)"])
    }

    @objc
    func onInterstitialAdOpened(_ unitId: String) -> Void {
        sendEvent(withName: "onInterstitialAdOpened", body: ["opened": true])
    }

    @objc
    func onInterstitialAdClosed(_ unitId: String) -> Void {
        sendEvent(withName: "onInterstitialAdClosed", body: ["opened": false])
    }

    // << Offerwall >>
    @objc(showOfferwall:)
    func showOfferwall(_ offerwallUnitID: String) -> Void {
        adiscope.showOfferwall(offerwallUnitID)
    }

    @objc
    func onOfferwallAdOpened(_ unitID: String) -> Void {
        sendEvent(withName: "onOfferwallAdOpened", body: ["opened": true])
    }

    @objc
    func onOfferwallAdClosed(_ unitID: String) -> Void {
        sendEvent(withName: "onOfferwallAdClosed", body: ["opened": false])
    }

    @objc
    func onOfferwallAdFailedToShow(_ unitID: String, error: AdiscopeError) -> Void {
        sendEvent(withName: "onOfferwallAdFailedToShow", body: ["opened": false, "error": error])
    }
}