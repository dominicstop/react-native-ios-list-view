import { View, ViewProps, ViewStyle } from 'react-native';
import { RNITableViewCellContentNativeViewBaseProps } from './RNITableViewCellContentNativeViewTypes';

// export type RNITableViewCellContentViewInheritedProps = Pick<RNITableViewCellContentNativeViewBaseProps,
//  | 'tba'
// >;

export type RNITableViewCellContentViewBaseProps = {
};

export type RNITableViewCellContentViewProps = 
    RNITableViewCellContentViewBaseProps 
  // & RNITableViewCellContentViewInheritedProps
  & ViewProps;

export type RNITableViewCellContentViewState = {
};