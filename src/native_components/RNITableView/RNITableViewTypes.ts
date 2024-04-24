import { ViewProps } from 'react-native';
import { RNITableNativeViewBaseProps } from './RNITableNativeViewTypes';
import { RNITableViewEditingConfig } from './RNITableViewEditingConfig';


export type RNITableViewInheritedProps = Pick<RNITableNativeViewBaseProps,
 | 'minimumListCellHeight'
 | 'shouldSetCellLoadingOnScrollToTop'
>;

export type RNITableViewListItem = {
  key: string;
};


export type RNITableViewBaseProps = {
  listData: Array<RNITableViewListItem>;
  isEditingConfig: RNITableViewEditingConfig | undefined;
  dragInteractionEnabled: boolean;
};

export type RNITableViewProps = 
    RNITableViewBaseProps 
  & RNITableViewInheritedProps
  & ViewProps;