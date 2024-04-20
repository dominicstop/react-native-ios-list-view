import { requireNativeModule } from 'expo-modules-core';
import { CGRectInit } from 'react-native-ios-utilities';

import { RenderRequestKey } from '../RNIRenderRequestView';
import { RNITableViewListItem } from '../RNITableView/RNITableViewTypes';


interface RNITableViewCellContentViewModule {
  notifyOnReactLayout(
    node: number,
    args: {
      layoutRect: CGRectInit;
      renderRequestKey: RenderRequestKey;
      listItem: RNITableViewListItem | undefined;
    },
  ): Promise<void>;
};

export const RNITableViewCellContentViewModule: RNITableViewCellContentViewModule = 
  requireNativeModule('RNITableViewCellContentView');