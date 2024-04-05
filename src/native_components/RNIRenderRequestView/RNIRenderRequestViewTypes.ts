import { View, ViewProps, ViewStyle } from 'react-native';
import { RNIRenderRequestNativeViewBaseProps } from './RNIRenderRequestNativeViewTypes';

// export type RNIRenderRequestViewInheritedProps = Pick<RNIRenderRequestNativeViewBaseProps,
//  | 'tba'
// >;

export type RNIRenderRequestViewRenderItem = (
  renderRequestItem: RenderRequestItem,
  index: number
) => React.ReactElement;

export type RNIRenderRequestViewBaseProps = {
  renderItemContainerStyle?: ViewStyle;
  renderItem: RNIRenderRequestViewRenderItem;
};

export type RNIRenderRequestViewProps = 
    RNIRenderRequestViewBaseProps 
  // & RNIRenderRequestViewInheritedProps
  & ViewProps;

export type RenderRequestItem = {
  renderRequestKey: number;
};

export type RenderRequestKey = RenderRequestItem['renderRequestKey'];

export type RNIRenderRequestViewState = {
  renderRequests: Array<RenderRequestItem>;
};