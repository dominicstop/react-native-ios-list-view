import { NativeSyntheticEvent } from "react-native";
import { RNITableViewListItem } from "../RNITableView/RNITableViewTypes";

export type OnDidSetListItemEventPayload = {
  listItem: RNITableViewListItem;
  orderedListItemIndex: number;
  reactListItemIndex: number;
};

export type OnDidSetListItemEventObject = 
  NativeSyntheticEvent<OnDidSetListItemEventPayload>;

export type OnDidSetListItemEvent = (
  event: OnDidSetListItemEventObject
) => void;