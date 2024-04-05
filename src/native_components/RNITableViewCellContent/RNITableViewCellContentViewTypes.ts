import { ViewProps } from 'react-native';
import { RNITableViewCellContentNativeViewBaseProps } from './RNITableViewCellContentNativeViewTypes';


export type RNITableViewCellContentViewInheritedProps = Pick<RNITableViewCellContentNativeViewBaseProps,
 | 'renderRequestKey'
>;

export type RNITableViewCellContentViewBaseProps = {
};

export type RNITableViewCellContentViewProps = 
    RNITableViewCellContentViewBaseProps 
  & RNITableViewCellContentViewInheritedProps
  & ViewProps;

export type RNITableViewCellContentViewState = {
};