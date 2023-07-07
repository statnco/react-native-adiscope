import { Reducer, useCallback, useEffect, useReducer } from 'react';
import { NativeModules, Platform, NativeEventEmitter } from 'react-native';

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
const eventEmitter = new NativeEventEmitter(RNAdiscopeModule);

const initialState: RewardedVideoState = {
  opened: false,
  rewarded: null,
  error: undefined,
};

interface RewardedState {
  unit: string;
  amount: number;
}

interface RewardedVideoState {
  opened: boolean;
  rewarded: RewardedState | null;
  error: any;
}

export default function useRewardedVideo(rewardedUnitId: string | null): any {
  const [state, setState] = useReducer<
    Reducer<RewardedVideoState, Partial<RewardedVideoState>>
  >((prevState, newState) => ({ ...prevState, ...newState }), initialState);
  useEffect(() => {
    const listeners = [
      eventEmitter.addListener('onRewardedVideoAdFailedToLoad', ({ error }) =>
        setState({ error })
      ),
      eventEmitter.addListener('onRewardedVideoAdOpened', ({ opened }) =>
        setState({ opened })
      ),
      eventEmitter.addListener('onRewardedVideoAdClosed', ({ opened }) =>
        setState({ opened })
      ),
      eventEmitter.addListener('onRewarded', ({ rewarded }) =>
        setState({ rewarded })
      ),
      eventEmitter.addListener('onRewardedVideoAdFailedToShow', ({ error }) =>
        setState({ error })
      ),
    ];
    return () => {
      listeners.forEach((listener) => listener?.remove());
    };
  }, []);

  const show = useCallback(async () => {
    return await new Promise((resolve, reject) => {
      try {
        setState({ error: undefined });
        RNAdiscopeModule.showRewardedVideo(rewardedUnitId);
        resolve(true);
      } catch (error) {
        reject(error);
      }
    });
  }, [rewardedUnitId]);

  return {
    ...state,
    show,
  };
}
