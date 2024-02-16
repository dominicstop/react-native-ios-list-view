import * as React from 'react';

import { ReactNativeIosCollectionViewProps } from './ReactNativeIosCollectionView.types';

export default function ReactNativeIosCollectionView(props: ReactNativeIosCollectionViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
