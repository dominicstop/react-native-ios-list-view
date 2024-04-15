import { ViewProps } from 'react-native';
import { RNITableNativeViewBaseProps } from './RNITableNativeViewTypes';


export type RNITableViewInheritedProps = Pick<RNITableNativeViewBaseProps,
 | 'minimumListCellHeight'
>;

export type RNITableViewListItem = {
  key: string;
};


export type RNITableViewBaseProps = {
  listData: Array<RNITableViewListItem>;
};

export type RNITableViewProps = 
    RNITableViewBaseProps 
  & RNITableViewInheritedProps
  & ViewProps;