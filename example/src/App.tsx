import * as React from 'react';

import { Button, StyleSheet, Text, View } from 'react-native';
import {
  AdiscopeView,
  initialize,
  showRewardedVideo,
  showOfferwall,
  showDetail,
  showInterstitial,
} from '@statnco/react-native-adiscope';

export default function App() {
  const rvUnitId: string = '';
  const offerwallUnitId: string = '';
  const offerwallItemId: number = 0;
  const interstitialUnitId: string = '';

  React.useEffect(() => {
    initialize();
  }, []);

  return (
    <View style={styles.container}>
      {/* <AdiscopeView color="#32a852" style={styles.box} /> */}
      <Text>React Native Adiscope Example</Text>
      <View style={styles.button}>
        <Button
          title="show RewardedVideo"
          color="#352561"
          onPress={() => showRewardedVideo(rvUnitId)}
        />
      </View>
      <View style={styles.button}>
        <Button
          title="show OfferWall"
          color="#643456"
          onPress={() => showOfferwall(offerwallUnitId)}
        />
      </View>
      <View style={styles.button}>
        <Button
          title="show OfferWall Item"
          color="#643456"
          onPress={() => showDetail(offerwallUnitId, offerwallItemId)}
        />
      </View>
      <View style={styles.button}>
        <Button
          title="show Interstitial"
          color="#549283"
          onPress={() => showInterstitial(interstitialUnitId)}
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
