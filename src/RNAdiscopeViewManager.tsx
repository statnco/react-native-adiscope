import {
  requireNativeComponent,
  UIManager,
  Platform,
  ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package '@statnco/react-native-adiscope' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type ReactNativeAdiscopeProps = {
  color: string;
  style: ViewStyle;
};

const ComponentName = 'RNAdiscopeViewManager';

export const RNAdiscopeViewManager =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<ReactNativeAdiscopeProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
