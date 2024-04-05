import { requireNativeViewManager } from 'expo-modules-core';
import type { RNITableViewCellContentNativeViewProps } from './RNITableViewCellContentNativeViewTypes';

export const RNITableViewCellContentNativeView: React.ComponentType<RNITableViewCellContentNativeViewProps> =
  requireNativeViewManager('RNITableViewCellContentView');
