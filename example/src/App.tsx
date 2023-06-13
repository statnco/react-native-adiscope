import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { AdiscopeView } from '@statnco/react-native-adiscope';

export default function App() {
  return (
    <View style={styles.container}>
      <AdiscopeView color="#32a852" style={styles.box} />
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
});
