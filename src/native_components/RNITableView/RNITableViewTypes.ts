import { ViewProps } from 'react-native';
import { RNITableNativeViewBaseProps } from './RNITableNativeViewTypes';


export type RNITableViewInheritedProps = Pick<RNITableNativeViewBaseProps,
 | 'minimumListCellHeight'
>;

export type RNITableViewListDataItem = {
  key: string;
};


export type RNITableViewBaseProps = {
  listData: Array<RNITableViewListDataItem>;
};

export type RNITableViewProps = 
    RNITableViewBaseProps 
  & RNITableViewInheritedProps
  & ViewProps;