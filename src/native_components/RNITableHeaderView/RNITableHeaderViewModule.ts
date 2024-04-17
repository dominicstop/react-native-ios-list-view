import { requireNativeModule } from 'expo-modules-core';
import { CGRectInit } from 'react-native-ios-utilities';


interface RNITableHeaderViewModule {
};

export const RNITableHeaderViewModule: RNITableHeaderViewModule = 
  requireNativeModule('RNITableHeaderView');