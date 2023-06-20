import { useRewardedVideo } from '@statnco/react-native-adiscope';
import React, { useEffect } from 'react';
import { Button } from 'react-native';

type Props = {
  onOpened: () => void;
  onClosed: () => void;
  onRewarded: () => void;
  onError: (error: any) => void;
};

const RewardedVideoButton = ({
  onOpened,
  onClosed,
  onRewarded,
  onError,
}: Props) => {
  const rewardVideoUnitId: string = '[yourRewardVideoUnitId]]';
  const { show, opened, rewarded, error } = useRewardedVideo(rewardVideoUnitId);

  useEffect(() => {
    if (opened) {
      onOpened();
    } else {
      onClosed();
    }
  }, [opened, onOpened, onClosed]);

  useEffect(() => {
    if (rewarded) {
      onRewarded();
    }
  }, [rewarded, onRewarded]);
  useEffect(() => {
    if (error) {
      onError(error);
    }
  }, [error, onError]);

  return (
    <Button
      title="show RewardedVideo"
      color="#352561"
      onPress={() => show(rewardVideoUnitId)}
    />
  );
};

export default RewardedVideoButton;
