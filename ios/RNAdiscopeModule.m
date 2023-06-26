//
//  RNAdiscopeModule.m
//  RNAdiscope
//
//  Created by surri on 6/14/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "RNAdiscopeModule.h"
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>

@implementation RNAdiscopeModule

{
  bool hasListeners;
}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// Will be called when this module's first listener is added.
- (void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
- (void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"onInitialized",
        @"onOfferwallAdOpened",
        @"onOfferwallAdClosed",
        @"onOfferwallAdFailedToShow",
        @"onRewardedVideoAdOpened",
        @"onRewardedVideoAdClosed",
        @"onRewarded",
        @"onRewardedVideoAdFailedToLoad",
        @"onRewardedVideoAdFailedToShow",
        @"onInterstitialAdOpened",
        @"onInterstitialAdClosed",
        @"onInterstitialAdFailedToLoad",
        @"onInterstitialAdFailedToShow",
    ];
}

// << Adiscope SDK Initialize >>
/// @param mediaId 사용하기 위한 Media의 고유한 ID
/// @param mediaSecret MediaID와 매칭되는 SecretKey
/// @param callBackTag 보상 콜백을 복수 개로 등록해서 사용할시에 어떤 보상 콜백을 사용할지 지정할 때 사용됩니다.

RCT_EXPORT_METHOD(initialize: (NSString *)mediaId mediaSecret:(NSString *)mediaSecret)
{
    [[AdiscopeInterface sharedInstance] setMainDelegate:self];
    [[AdiscopeInterface sharedInstance] initialize:mediaId mediaSecret:mediaSecret callBackTag:@""];
}

// initialize callback
- (void)onInitialized:(bool) isSuccess {
    @try {
        [self sendEventWithName:@"onInitialized" body:@{
            @"initialized": @(isSuccess),
        }];
    } @catch (NSException *exception) {
        NSLog(@"Debug: %@", exception);
    }
}

RCT_EXPORT_METHOD(setUserId: (NSString *)userId resolver:(RCTPromiseResolveBlock) resolve rejecter:(RCTPromiseRejectBlock) reject) {
    @try {
        [[AdiscopeInterface sharedInstance] setUserId:userId];
        resolve(userId);
    } @catch (NSException *exception) {
        reject(@"exception", @"setUserId failure", nil);
    }
}

RCT_EXPORT_METHOD(isRVLoaded:(NSString *)unitId Callback:(RCTResponseSenderBlock) callback)
{
    callback(@[@([[AdiscopeInterface sharedInstance] isLoaded:unitId])]);
}

// << Rewarded Video >>
RCT_EXPORT_METHOD(showRewardedVideo: (NSString *)rewardedVideoUnitID)
{
    RCTLogInfo(@">>> rewarded video unit id %@", rewardedVideoUnitID);
    [[AdiscopeInterface sharedInstance] load:rewardedVideoUnitID];
}
// rv callbacks
- (void)onRewardedVideoAdLoaded:(NSString *)unitID {
    RCTLogInfo(@">>> onRewardedVideoAdLoaded");
    [[AdiscopeInterface sharedInstance] show];
}
- (void)onRewardedVideoAdFailedToLoad:(NSString *)unitID Error:(AdiscopeError *)error {

    RCTLogInfo(@">>> onRewardedVideoAdFailedToLoad\n%@", error);

    @try {
        NSString *errorMessage = [NSString stringWithFormat:@"%@", error];
        [self sendEventWithName:@"onRewardedVideoAdFailedToLoad" body:@{
            @"error": errorMessage,
        }];
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}
- (void)onRewardedVideoAdOpened:(NSString *)unitID {
    RCTLogInfo(@">>> onRewardedVideoAdOpened");
}
- (void)onRewardedVideoAdClosed:(NSString *)unitID {
    RCTLogInfo(@">>> onRewardedVideoAdClosed");
}
- (void)onRewardedVideoAdFailedToShow:(NSString *)unitID Error:(AdiscopeError *)error {
    RCTLogInfo(@">>> onRewardedVideoAdFailedToShow\n%@",error);
}

// << Interstitial >>
RCT_EXPORT_METHOD(showInterstitial: (NSString *)interstitialUnitID)
{
    RCTLogInfo(@">>> interstitial unit id %@", interstitialUnitID);
    [[AdiscopeInterface sharedInstance] loadInterstitial:interstitialUnitID];
}
// interstitial callbacks
- (void)onInterstitialAdLoaded {
    RCTLogInfo(@">>> onInterstitialAdLoaded");
    [[AdiscopeInterface sharedInstance] showInterstitial];
}
- (void)onInterstitialAdFailedToLoad:(NSString *)unitID Error:(AdiscopeError *)error {
    RCTLogInfo(@">>> onInterstitialAdFailedToLoad\n%@", error);

    @try {
        NSString *errorMessage = [NSString stringWithFormat:@"%@", error];
        [self sendEventWithName:@"onInterstitialAdFailedToLoad" body:@{
            @"error": errorMessage,
        }];
    } @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}
- (void)onInterstitialAdFailedToShow:(NSString *)unitID Error:(AdiscopeError *)error {
    RCTLogInfo(@">>> onInterstitialAdFailedToShow\n%@", error);
}
// << Offerwall >>
RCT_EXPORT_METHOD(showOfferwall: (NSString *)offerwallUnitID)
{
    RCTLogInfo(@">>> interstitial unit id %@", offerwallUnitID);
    [[AdiscopeInterface sharedInstance] showOfferwall:offerwallUnitID];
}

- (void)onOfferwallAdOpened:(NSString *)unitID {
    @try {
        [self sendEventWithName:@"onOfferwallAdOpened" body:@{
            @"opened": @(YES),
        }];
    } @catch (NSException *exception) {
        NSLog(@"Debug: %@", exception);
    }
}
- (void)onOfferwallAdClosed:(NSString *)unitID {
    @try {
        [self sendEventWithName:@"onOfferwallAdClosed" body:@{
            @"opened": @(NO),
        }];
    } @catch (NSException *exception) {
        NSLog(@"Debug: %@", exception);
    }
}
- (void)onOfferwallAdFailedToShow:(NSString *)unitId Error:(AdiscopeError *)error {
    RCTLogInfo(@">>> onOfferwallAdFailedToShow\n%@", error);
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRNAdiscopeModuleSpecJSI>(params);
}

#endif

@end

