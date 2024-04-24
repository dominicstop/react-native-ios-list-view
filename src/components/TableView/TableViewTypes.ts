import { ViewProps, ViewStyle } from "react-native";

import { RenderRequestItem } from "../../native_components/RNIRenderRequestView";
import { RNITableViewCellContentViewState } from "../../native_components/RNITableViewCellContent";
import { RNITableViewProps } from "../../native_components/RNITableView";


export type TableViewInheritedRequiredProps = Pick<RNITableViewProps, 
 | 'minimumListCellHeight'
>;

export type TableViewInheritedOptionalProps = Partial<Pick<RNITableViewProps, 
 | 'isEditingConfig'
 | 'dragInteractionEnabled'
 | 'shouldSetCellLoadingOnScrollToTop'
 | 'minVerticalContentOffsetToTriggerCellLoading'
>>;

export type TableViewInheritedProps = 
  & TableViewInheritedRequiredProps
  & TableViewInheritedOptionalProps;

export type TableViewListData = Record<string, any>;

export type TableViewRenderItem = () => React.ReactElement;

export type TableViewRenderCellContent = (
  listDataItem: TableViewListData[number],
  renderRequestData: RenderRequestItem,

  orderedListItemIndex: 
    RNITableViewCellContentViewState['orderedListItemIndex'],

  reactListItemIndex: 
    RNITableViewCellContentViewState['reactListItemIndex'],

  nativeListDataItem: 
    RNITableViewCellContentViewState['listItem'],

) => React.ReactElement;

export type ListDataKeyExtractor<T extends object> = (
  listDataItem: T,
  index: number
) => string;

export type TableViewBaseProps = {
  initialCellsToRenderCount?: number;
  listData: TableViewListData;
  cellContentContainerStyle?: ViewStyle;
  tableHeaderContainerStyle?: ViewStyle;

  listDataKeyExtractor: ListDataKeyExtractor<Record<string, any>>;
  renderCellContent: TableViewRenderCellContent;
  renderListHeader?: TableViewRenderItem;
};

export type TableViewProps = 
  & TableViewInheritedProps
  & TableViewBaseProps 
  & ViewProps;

export type TableViewState = {
  tableViewWidth: number;
};