import { requireNativeViewManager } from 'expo-modules-core';
import type { RNICollectionNativeViewProps } from './RNICollectionNativeViewTypes';

export const RNICollectionNativeView: React.ComponentType<RNICollectionNativeViewProps> =
  requireNativeViewManager('RNICollectionView');
