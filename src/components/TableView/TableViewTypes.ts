import { ViewProps } from "react-native";
import { RNITableViewBaseProps, RNITableViewListDataItem } from "../../native_components/RNITableView";

// export type TableViewInheritedProps = Pick<RNITableViewBaseProps, 
//  | ''
// >;

export type ListDataKeyExtractor<T extends object> = (
  listDataItem: T,
  index: number
) => string;

export type TableViewBaseProps = {
  listData: Array<object>;
  listDataKeyExtractor: ListDataKeyExtractor<Record<string, any>>;
};

export type TableViewProps = 
  // & TableViewInheritedProps
  & TableViewBaseProps 
  & ViewProps;

export type TableViewState = {
  // TBA
};