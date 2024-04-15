import { NativeSyntheticEvent } from "react-native";
import { RNITableViewListItem } from "../RNITableView/RNITableViewTypes";

export type OnDidSetListDataEntryEventPayload = {
  listDataEntry: RNITableViewListItem;
  orderedListDataEntryIndex: number;
  reactListDataEntryIndex: number;
};

export type OnDidSetListDataEntryEventObject = 
  NativeSyntheticEvent<OnDidSetListDataEntryEventPayload>;

export type OnDidSetListDataEntryEvent = (
  event: OnDidSetListDataEntryEventObject
) => void;