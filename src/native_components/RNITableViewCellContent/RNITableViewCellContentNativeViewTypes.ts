import type { ViewProps } from 'react-native';

import { RenderRequestKey } from '../RNIRenderRequestView';
import { OnDidSetListDataEntryEvent } from './RNITableViewCellContentNativeViewEvents';


export type RNITableViewCellContentNativeViewBaseProps = {
  renderRequestKey: RenderRequestKey;
  onDidSetListDataEntry: OnDidSetListDataEntryEvent;
};

export type RNITableViewCellContentNativeViewProps = 
  RNITableViewCellContentNativeViewBaseProps & ViewProps;