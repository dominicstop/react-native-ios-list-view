import { NativeSyntheticEvent } from "react-native";
import { RNITableViewListDataItem } from "../RNITableView/RNITableViewTypes";

export type OnDidSetListDataEntryEventPayload = {
  listDataEntry: RNITableViewListDataItem;
  orderedListDataEntryIndex: number;
  reactListDataEntryIndex: number;
};

export type OnDidSetListDataEntryEventObject = 
  NativeSyntheticEvent<OnDidSetListDataEntryEventPayload>;

export type OnDidSetListDataEntryEvent = (
  event: OnDidSetListDataEntryEventObject
) => void;