import React, { useEffect } from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import RewardedVideoButton from './components/RewardedVideoButton';
import OfferwallButton from './components/OfferwallButton';
import InterstitialButton from './components/InterstitialButton';
import { setUserId, initialize } from '@statnco/react-native-adiscope';

export default function App() {
  useEffect(() => {
    initialize('[yourMediaId]', '[yourMediaSecret]');
  }, []);

  return (
    <View style={styles.container}>
      <Text>React Native Adiscope Example</Text>
      <View style={styles.button}>
        <TouchableOpacity onPress={setUserId('[uniqueUserId]')}>
          <Text>setUserId</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.button}>
        <RewardedVideoButton
          onOpened={() => console.log('on RewardedVideo Opened')}
          onClosed={() => console.log('on RewardedVideo Closed')}
          onRewarded={() => console.log('get Rewarded')}
          onError={(error) => console.warn(error)}
        />
      </View>
      <View style={styles.button}>
        <OfferwallButton
          onOpened={() => console.log('on Offerwall Opened')}
          onClosed={() => console.log('on Offerwall Closed')}
          onError={(error) => console.warn(error)}
        />
      </View>
      <View style={styles.button}>
        <InterstitialButton
          onOpened={() => console.log('on Offerwall Opened')}
          onClosed={() => console.log('on Offerwall Closed')}
          onError={(error) => console.warn(error)}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 240,
    height: 240,
    marginVertical: 20,
  },
  button: {
    marginVertical: 10,
  },
});
