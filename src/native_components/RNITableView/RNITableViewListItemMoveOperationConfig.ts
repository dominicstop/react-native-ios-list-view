import { RNITableViewListItemTargetPositionConfig } from "./RNITableViewListItemTargetPositionConfig";

export type RNITableViewListItemMoveOperationMode = {
  mode: 'moveToSpecificPosition';
  destinationKey: RNITableViewListItemTargetPositionConfig;
  shouldMoveItemAfterDestination: boolean;
} | {
  mode: 'moveUp';
  numberOfPlaces: number;
} | {
  mode: 'moveDown';
  numberOfPlaces: number;
};

export type RNITableViewListItemMoveOperationBaseConfig = {
  sourceConfig: RNITableViewListItemTargetPositionConfig; 
  animatingDifference: boolean;
};

export type RNITableViewListItemMoveOperationConfig = 
  & RNITableViewListItemMoveOperationBaseConfig
  & RNITableViewListItemMoveOperationMode;