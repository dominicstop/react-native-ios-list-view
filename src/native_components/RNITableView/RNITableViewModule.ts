import { requireNativeModule } from 'expo-modules-core';
import { RNITableViewListItemMoveOperationConfig } from './RNITableViewListItemMoveOperationConfig';

interface RNITableViewModule  {
  requestToMoveListItem: (
    reactTag: number,
    args: RNITableViewListItemMoveOperationConfig
  ) => Promise<void>;
};

export const RNITableViewModule: RNITableViewModule = 
  requireNativeModule('RNITableView');