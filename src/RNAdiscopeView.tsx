import React, { useEffect, useRef } from 'react';
import { UIManager, PixelRatio, findNodeHandle } from 'react-native';
import { RNAdiscopeViewManager } from './RNAdiscopeViewManager';

const createFragment = (viewId) =>
  UIManager.dispatchViewManagerCommand(
    viewId,
    UIManager.RNAdiscopeViewManager.Commands.create.toString(),
    [viewId]
  );

export const RNAdiscopeView = (props) => {
  const ref = useRef(null);
  useEffect(() => {
    const viewId = findNodeHandle(ref.current);
    createFragment(viewId);
  }, []);

  const _onChange = (event) => {
    if (!props.onChangeMessage) {
      return;
    }
    props.onChangeMessage(event.nativeEvent.message);
  };
  return (
    <RNAdiscopeViewManager
      {...props}
      onChange={_onChange}
      style={{
        // converts dpi to px, provide desired height
        height: PixelRatio.getPixelSizeForLayoutSize(120),
        // converts dpi to px, provide desired width
        width: PixelRatio.getPixelSizeForLayoutSize(120),
      }}
      ref={ref}
    />
  );
};
