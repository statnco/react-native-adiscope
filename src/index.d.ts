export declare const initialize: (
  mediaId?: string,
  mediaSecret?: string
) => Promise<boolean>;
export declare const setUserId: (userId: string) => Promise<boolean>;
export declare const useRewardedVideo: (rewardedVideoUnitId: string) => {
  show: (rewardedVideoUnitId: string) => Promise<boolean>;
  opened: boolean;
  rewarded: boolean;
  error: any;
};
export declare const useInterstitial: (interstitialUnitId: string) => {
  show: (interstitialUnitId: string) => Promise<boolean>;
  opened: boolean;
  error: any;
};
export declare const useOfferwall: (offerwallUnitId: string) => {
  show: (offerwallUnitId: string) => Promise<boolean>;
  opened: boolean;
  error: any;
};
