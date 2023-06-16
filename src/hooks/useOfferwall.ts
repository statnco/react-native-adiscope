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

const initialState: OfferwallState = {
  opened: false,
  error: undefined,
};

interface OfferwallState {
  opened: boolean;
  error: any;
}

export default function useOfferwall(offerwallUnitId: string | null): any {
  const [state, setState] = useReducer<
    Reducer<OfferwallState, Partial<OfferwallState>>
  >((prevState, newState) => ({ ...prevState, ...newState }), initialState);

  const show = useCallback(async () => {
    return await new Promise((resolve) => {
      try {
        RNAdiscopeModule.showOfferwall(offerwallUnitId);
        resolve(true);
      } catch (error) {
        resolve(error);
      }
    });
  }, [offerwallUnitId]);

  useEffect(() => {
    const listeners = [
      eventEmitter.addListener('onOfferwallAdOpened', (res) => {
        setState({ opened: true });
      }),
      eventEmitter.addListener('onOfferwallAdFailedToShow', (error) =>
        setState({ error })
      ),
      eventEmitter.addListener('onOfferwallAdClosed', (res) => {
        setState({ opened: false });
      }),
    ];

    return () => {
      listeners.forEach((listener) => listener?.remove());
    };
  }, []);
  return {
    ...state,
    show,
  };
}
