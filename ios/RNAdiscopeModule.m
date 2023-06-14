//
//  RNAdiscopeModule.m
//  RNAdiscope
//
//  Created by surri on 6/14/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "RNAdiscopeModule.h"
#import <Foundation/Foundation.h>
#import <React/RCTLog.h>

@implementation RNAdiscopeModule
RCT_EXPORT_MODULE()

// << Adiscope SDK Initialize >>
/// @param mediaId 사용하기 위한 Media의 고유한 ID
/// @param mediaSecret MediaID와 매칭되는 SecretKey
/// @param callBackTag 보상 콜백을 복수 개로 등록해서 사용할시에 어떤 보상 콜백을 사용할지 지정할 때 사용됩니다.
RCT_EXPORT_METHOD(initialize)
{
    [[AdiscopeInterface sharedInstance] setMainDelegate:self];
    [[AdiscopeInterface sharedInstance] setUserId:@""];
    [[AdiscopeInterface sharedInstance] initialize:@"" mediaSecret:@"" callBackTag:@""];
}

// initialize callback
- (void)onInitialized:(BOOL)isSuccess {
    RCTLogInfo(@">>> %d", isSuccess);
}

// << setUserId >>
RCT_EXPORT_METHOD(setUserId: (NSString *)userId) {
    [[AdiscopeInterface sharedInstance] setUserId:userId];
}
// callback example
RCT_EXPORT_METHOD(isRVLoaded:(NSString *)unitId Callback:(RCTResponseSenderBlock)callback)
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
    RCTLogInfo(@">>> onRewardedVideoAdFailedToLoad");
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

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRNAdiscopeModuleSpecJSI>(params);
}

#endif

@end
