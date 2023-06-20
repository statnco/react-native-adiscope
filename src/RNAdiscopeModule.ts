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

export const initialize = (mediaId: string, mediaSecret: string) => {
  RNAdiscopeModule.initialize(mediaId, mediaSecret);
};

export const setUserId = (userId: string) => {
  RNAdiscopeModule.setUserId(userId);
};
