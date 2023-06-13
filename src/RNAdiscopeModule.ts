import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@statnco/react-native-adiscope' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const RNAdiscopeModule = NativeModules.RNAdiscopeModule
  ? NativeModules.RNAdiscopeModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export const adInitialize = () => {
  RNAdiscopeModule.adInitialize();
};

export const showRewardedVideo = (rvUnitId: string) => {
  RNAdiscopeModule.showRewardedVideo(rvUnitId);
};
export const showOfferwall = (offerwallUnitId: string) => {
  console.log(JSON.stringify(RNAdiscopeModule));
  RNAdiscopeModule.showOfferwall(offerwallUnitId);
};
export const showDetail = (
  offerwallUnitId: string,
  offerwallItemId: number
) => {
  RNAdiscopeModule.showDetail(offerwallUnitId, offerwallItemId);
};
export const showInterstitial = (interstitialUnitId: string) => {
  RNAdiscopeModule.showInterstitial(interstitialUnitId);
};
