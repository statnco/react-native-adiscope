import { NativeModules, NativeEventEmitter, Platform } from 'react-native';

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

export const initialize = (mediaId: string, mediaSecret: string) => {
  Platform.OS === 'ios'
    ? RNAdiscopeModule.initialize(mediaId, mediaSecret)
    : RNAdiscopeModule.initialize();
};

export const setUserId = (userId: string) => {
  RNAdiscopeModule.setUserId(userId)
    .then((data: any) => {
      console.log({ data });
    })
    .catch((error: any) => {
      console.log(JSON.stringify(error));
    });
};

eventEmitter.addListener('onInitialized', (data: any) =>
  console.log('onInitialized', data)
);
