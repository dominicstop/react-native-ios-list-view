import type { ViewProps } from 'react-native';


export type TableViewListItem = {
};

export type RNITableNativeViewBaseProps = {
  data: Array<TableViewListItem>;
  minimumListCellHeight: number;
};

export type RNITableNativeViewProps = 
  RNITableNativeViewBaseProps & ViewProps;