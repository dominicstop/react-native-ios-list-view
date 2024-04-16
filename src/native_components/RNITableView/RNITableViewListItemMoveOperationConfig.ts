import { RNITableViewListItemTargetPositionConfig } from "./RNITableViewListItemTargetPositionConfig";

export type RNITableViewListItemMoveOperationMode = {
  mode: 'moveToSpecificPosition';
  destinationConfig: RNITableViewListItemTargetPositionConfig;
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
  shouldAnimateDifference: boolean;
};

export type RNITableViewListItemMoveOperationConfig = 
  & RNITableViewListItemMoveOperationBaseConfig
  & RNITableViewListItemMoveOperationMode;