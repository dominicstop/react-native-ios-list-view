import type { ViewProps } from 'react-native';
import { OnRenderRequestEvent } from './RNIRenderRequestNativeViewEvents';


export type RNIRenderRequestNativeViewBaseProps = {
  onRenderRequest: OnRenderRequestEvent;
};

export type RNIRenderRequestNativeViewProps = 
  RNIRenderRequestNativeViewBaseProps & ViewProps;