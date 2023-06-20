import { useOfferwall } from '@statnco/react-native-adiscope';
import React, { useEffect } from 'react';
import { Button } from 'react-native';

type Props = {
  onOpened: () => void;
  onClosed: () => void;
  onError: (error: any) => void;
};

const OfferwallButton = ({ onOpened, onClosed, onError }: Props) => {
  const offerwallUnitId: string = '[youroOferwallUnitId]';
  const { show, opened, error } = useOfferwall(offerwallUnitId);

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
      title="show OfferWall"
      color="#643456"
      onPress={() => show(offerwallUnitId)}
    />
  );
};

export default OfferwallButton;
