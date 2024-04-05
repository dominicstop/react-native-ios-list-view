import { requireNativeViewManager } from 'expo-modules-core';
import type { RNIRenderRequestNativeViewProps } from './RNIRenderRequestNativeViewTypes';

export const RNITableViewCellContentNativeView: React.ComponentType<RNIRenderRequestNativeViewProps> =
  requireNativeViewManager('RNITableViewCellContentView');
