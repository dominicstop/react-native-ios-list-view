import { View, ViewProps, ViewStyle } from 'react-native';
import { RNIRenderRequestNativeViewBaseProps } from './RNIRenderRequestNativeViewTypes';

// export type RNIRenderRequestViewInheritedProps = Pick<RNIRenderRequestNativeViewBaseProps,
//  | 'tba'
// >;

export type RNIRenderRequestViewBaseProps = {
  renderItem: (
    renderRequestItem: RenderRequestItem,
    index: number
  ) => React.ReactElement;
  renderItemContainerStyle?: ViewStyle;
};

export type RNIRenderRequestViewProps = 
    RNIRenderRequestViewBaseProps 
  // & RNIRenderRequestViewInheritedProps
  & ViewProps;

export type RenderRequestItem = {
  renderRequestKey: number;
};

export type RNIRenderRequestViewState = {
  renderRequests: Array<RenderRequestItem>;
};