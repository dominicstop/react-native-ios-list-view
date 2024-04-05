import { View, ViewProps, ViewStyle } from 'react-native';
import { RNITableViewCellContentNativeViewBaseProps } from './RNITableViewCellContentNativeViewTypes';

// export type RNITableViewCellContentViewInheritedProps = Pick<RNITableViewCellContentNativeViewBaseProps,
//  | 'tba'
// >;

export type RNITableViewCellContentViewBaseProps = {
  renderItem: (
    renderRequestItem: RenderRequestItem,
    index: number
  ) => React.ReactElement;
  renderItemContainerStyle?: ViewStyle;
};

export type RNITableViewCellContentViewProps = 
    RNITableViewCellContentViewBaseProps 
  // & RNITableViewCellContentViewInheritedProps
  & ViewProps;

export type RenderRequestItem = {
  renderRequestKey: number;
};

export type RNITableViewCellContentViewState = {
  renderRequests: Array<RenderRequestItem>;
};