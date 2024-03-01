import { requireNativeViewManager } from 'expo-modules-core';
import type { RNITableNativeViewProps } from './RNITableNativeViewTypes';

export const RNITableNativeView: React.ComponentType<RNITableNativeViewProps> =
  requireNativeViewManager('RNITableView');
