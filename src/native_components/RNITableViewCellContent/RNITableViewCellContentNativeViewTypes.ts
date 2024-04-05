import type { ViewProps } from 'react-native';
import { RenderRequestKey } from '../RNIRenderRequestView';


export type RNITableViewCellContentNativeViewBaseProps = {
  renderRequestKey: RenderRequestKey;
};

export type RNITableViewCellContentNativeViewProps = 
  RNITableViewCellContentNativeViewBaseProps & ViewProps;