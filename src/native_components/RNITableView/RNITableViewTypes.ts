import { ViewProps } from 'react-native';
import { RNITableNativeViewBaseProps } from './RNITableNativeViewTypes';


// export type RNITableViewInheritedProps = Pick<RNITableNativeViewBaseProps,
//  | 'tba'
// >;

export type RNITableViewBaseProps = {
};

export type RNITableViewProps = 
    RNITableViewBaseProps 
  // & RNITableViewInheritedProps
  & ViewProps;