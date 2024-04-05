import { View, ViewProps, ViewStyle } from "react-native";
import { RNIRenderRequestViewProps, RenderRequestItem } from "../../native_components/RNIRenderRequestView";

// export type TableViewInheritedProps = Pick<RNITableViewBaseProps, 
//  | ''
// >;

export type TableViewRenderCellContent = (
  renderRequestData: RenderRequestItem
) => React.ReactElement;

export type ListDataKeyExtractor<T extends object> = (
  listDataItem: T,
  index: number
) => string;

export type TableViewBaseProps = {
  listData: Array<object>;
  listDataKeyExtractor: ListDataKeyExtractor<Record<string, any>>;
  renderCellContent: TableViewRenderCellContent;
  cellContentContainerStyle?: ViewStyle;
};

export type TableViewProps = 
  // & TableViewInheritedProps
  & TableViewBaseProps 
  & ViewProps;

export type TableViewState = {
  // TBA
};