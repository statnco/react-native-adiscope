import { useInterstitial } from '@statnco/react-native-adiscope';
import React, { useEffect } from 'react';
import { Button } from 'react-native';

type Props = {
  onOpened: () => void;
  onClosed: () => void;
  onError: (error: any) => void;
};

const InterstitialButton = ({ onOpened, onClosed, onError }: Props) => {
  const interstitialUnitId: string = '[yourInterstitialUnitId]';
  const { show, opened, error } = useInterstitial(interstitialUnitId);

  useEffect(() => {
    if (opened) {
      onOpened();
    } else {
      onClosed();
    }
  }, [opened, onOpened, onClosed]);

  useEffect(() => {
    if (error) {
      onError(error);
    }
  }, [error, onError]);

  return (
    <Button
      title="show Interstitial"
      color="#549283"
      onPress={() => show(interstitialUnitId)}
    />
  );
};

export default InterstitialButton;
