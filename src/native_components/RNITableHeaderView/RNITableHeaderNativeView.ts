import { requireNativeViewManager } from 'expo-modules-core';
import type { RNITableHeaderNativeViewProps } from './RNITableHeaderNativeViewTypes';

export const RNITableHeaderNativeView: React.ComponentType<RNITableHeaderNativeViewProps> =
  requireNativeViewManager('RNITableHeaderView');
