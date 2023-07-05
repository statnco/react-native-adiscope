//
//  RNAdiscopeModule.m
//  RNAdiscope
//
//  Created by surri on 6/14/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNAdiscopeModule, RCTEventEmitter)

RCT_EXTERN_METHOD(
    initialize: (NSString *) mediaId
    mediaSecret: (NSString *) mediaSecret
)

RCT_EXTERN_METHOD(
    setUserId: (NSString *) userId
    resolver: (RCTPromiseResolveBlock *) resolve
    rejecter:(RCTPromiseRejectBlock *) reject
)

// << Rewarded Video >>
RCT_EXTERN_METHOD(
    isRVLoaded:  (NSString *) unitId
    Callback: (RCTResponseSenderBlock *) callback
)

RCT_EXTERN_METHOD(
    showRewardedVideo:  (NSString *) rewardedVideoUnitID
)

// << Offerwall >>
RCT_EXTERN_METHOD(
    showOfferwall:  (NSString *) offerwallUnitID
)

// << Interstitial >>
RCT_EXTERN_METHOD(
    showInterstitial:  (NSString *) interstitialUnitID
)

@end
