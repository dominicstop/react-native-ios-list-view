import { ViewProps, ViewStyle } from "react-native";

import { RenderRequestItem } from "../../native_components/RNIRenderRequestView";
import { RNITableViewCellContentViewState } from "../../native_components/RNITableViewCellContent";
import { RNITableViewProps } from "../../native_components/RNITableView";


export type TableViewInheritedProps = Pick<RNITableViewProps, 
 | 'minimumListCellHeight'
>;

export type TableViewListData = Record<string, any>;

export type TableViewRenderCellContent = (
  listDataItem: TableViewListData[number],
  
  renderRequestData: RenderRequestItem,
  orderedListDataEntryIndex: 
    RNITableViewCellContentViewState['orderedListDataEntryIndex'],

  reactListDataEntryIndex: 
    RNITableViewCellContentViewState['reactListDataEntryIndex'],
) => React.ReactElement;

export type ListDataKeyExtractor<T extends object> = (
  listDataItem: T,
  index: number
) => string;

export type TableViewBaseProps = {
  listData: TableViewListData;
  listDataKeyExtractor: ListDataKeyExtractor<Record<string, any>>;
  renderCellContent: TableViewRenderCellContent;
  cellContentContainerStyle?: ViewStyle;
};

export type TableViewProps = 
  & TableViewInheritedProps
  & TableViewBaseProps 
  & ViewProps;

export type TableViewState = {
  tableViewWidth: number;
};