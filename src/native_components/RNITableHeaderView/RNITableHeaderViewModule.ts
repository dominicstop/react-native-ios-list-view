import { requireNativeModule } from 'expo-modules-core';
import { CGRectInit } from 'react-native-ios-utilities';


interface RNITableHeaderViewModule {
  notifyOnReactLayout(
    node: number,
    args: {
      layoutRect: CGRectInit,
    },
  ): Promise<void>;
};

export const RNITableHeaderViewModule: RNITableHeaderViewModule = 
  requireNativeModule('RNITableHeaderView');