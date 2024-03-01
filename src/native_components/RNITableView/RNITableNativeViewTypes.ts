import type { ViewProps } from 'react-native';


export type TableViewListItem = {
};

export type RNITableNativeViewBaseProps = {
  // TBA
  data: Array<TableViewListItem>;
};

export type RNITableNativeViewProps = 
  RNITableNativeViewBaseProps & ViewProps;