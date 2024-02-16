import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ReactNativeIosCollectionViewProps } from './ReactNativeIosCollectionView.types';

const NativeView: React.ComponentType<ReactNativeIosCollectionViewProps> =
  requireNativeViewManager('ReactNativeIosCollectionView');

export default function ReactNativeIosCollectionView(props: ReactNativeIosCollectionViewProps) {
  return <NativeView {...props} />;
}
