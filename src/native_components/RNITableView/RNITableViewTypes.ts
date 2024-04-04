import { ViewProps } from 'react-native';
import { RNITableNativeViewBaseProps } from './RNITableNativeViewTypes';


// export type RNITableViewInheritedProps = Pick<RNITableNativeViewBaseProps,
//  | 'tba'
// >;

export type RNITableViewListDataItem<T = object> = {
  key: string;
  data: T;
};


export type RNITableViewBaseProps = {
  listData: Array<RNITableViewListDataItem>;
};

export type RNITableViewProps = 
    RNITableViewBaseProps 
  // & RNITableViewInheritedProps
  & ViewProps;