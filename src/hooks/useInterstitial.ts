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

const initialState: interstitialState = {
  opened: false,
  rewarded: false,
  error: undefined,
};

interface interstitialState {
  opened: boolean;
  rewarded: boolean;
  error: any;
}

export default function useInterstitial(
  interstitialUnitId: string | null
): any {
  const [state, setState] = useReducer<
    Reducer<interstitialState, Partial<interstitialState>>
  >((prevState, newState) => ({ ...prevState, ...newState }), initialState);

  useEffect(() => {
    const listeners = [
      eventEmitter.addListener('onInterstitialAdFailedToLoad', ({ error }) =>
        setState({ error })
      ),
      eventEmitter.addListener('onInterstitialAdOpened', ({ opened }) =>
        setState({ opened })
      ),
      eventEmitter.addListener('onInterstitialAdClosed', ({ opened }) =>
        setState({ opened })
      ),
      eventEmitter.addListener('onInterstitialAdFailedToShow', ({ error }) =>
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
        RNAdiscopeModule.showInterstitial(interstitialUnitId);
        resolve(true);
      } catch (error) {
        reject(error);
      }
    });
  }, [interstitialUnitId]);

  return {
    ...state,
    show,
  };
}
