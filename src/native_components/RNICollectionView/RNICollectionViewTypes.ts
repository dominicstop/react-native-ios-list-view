import { ViewProps } from 'react-native';
import { RNICollectionNativeViewBaseProps } from './RNICollectionNativeViewTypes';


// export type RNICollectionViewInheritedProps = Pick<RNICollectionNativeViewBaseProps,
//  | 'tba'
// >;

export type RNICollectionViewBaseProps = {
};

export type RNICollectionViewProps = 
    RNICollectionViewBaseProps 
  // & RNICollectionViewInheritedProps
  & ViewProps;