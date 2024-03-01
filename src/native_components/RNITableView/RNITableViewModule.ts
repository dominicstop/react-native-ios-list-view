import { requireNativeModule } from 'expo-modules-core';

interface RNITableViewModule  {
};

export const RNITableViewModule: RNITableViewModule = 
  requireNativeModule('RNITableView');