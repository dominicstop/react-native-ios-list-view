import type { ViewProps } from 'react-native';

import { RenderRequestKey } from '../RNIRenderRequestView';
import { OnDidSetListItemEvent } from './RNITableViewCellContentNativeViewEvents';


export type RNITableViewCellContentNativeViewBaseProps = {
  renderRequestKey: RenderRequestKey;
  onDidSetListItem: OnDidSetListItemEvent;
};

export type RNITableViewCellContentNativeViewProps = 
  RNITableViewCellContentNativeViewBaseProps & ViewProps;