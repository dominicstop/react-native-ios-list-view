import { requireNativeModule } from 'expo-modules-core';
import { CGRectInit } from 'react-native-ios-utilities';

interface RNITableViewCellContentViewModule {
  notifyOnReactLayout(
    node: number,
    args: CGRectInit
  ): Promise<void>;
};

export const RNITableViewCellContentViewModule: RNITableViewCellContentViewModule = 
  requireNativeModule('RNITableViewCellContentView');