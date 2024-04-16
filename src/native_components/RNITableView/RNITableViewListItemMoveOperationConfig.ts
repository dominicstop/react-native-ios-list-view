import { RNITableViewListItemTargetPositionConfig } from "./RNITableViewListItemTargetPositionConfig";

export type RNITableViewListItemMoveOperationConfig = {
  sourceConfig: RNITableViewListItemTargetPositionConfig; 
  destinationKey: RNITableViewListItemTargetPositionConfig;
  
  animatingDifference: boolean;
  shouldMoveItemAfterDestination: boolean;
};