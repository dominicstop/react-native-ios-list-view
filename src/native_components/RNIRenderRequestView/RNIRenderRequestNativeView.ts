import { requireNativeViewManager } from 'expo-modules-core';
import type { RNIRenderRequestNativeViewProps } from './RNIRenderRequestNativeViewTypes';

export const RNIRenderRequestNativeView: React.ComponentType<RNIRenderRequestNativeViewProps> =
  requireNativeViewManager('RNIRenderRequestView');
