import { requireNativeModule } from 'expo-modules-core';
import { CGRectInit } from 'react-native-ios-utilities';

import { RenderRequestKey } from '../RNIRenderRequestView';


interface RNITableViewCellContentViewModule {
  notifyOnReactLayout(
    node: number,
    args: {
      layoutRect: CGRectInit,
      renderRequestKey: RenderRequestKey,
    },
  ): Promise<void>;
};

export const RNITableViewCellContentViewModule: RNITableViewCellContentViewModule = 
  requireNativeModule('RNITableViewCellContentView');