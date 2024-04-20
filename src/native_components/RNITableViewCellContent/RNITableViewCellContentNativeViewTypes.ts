import type { ViewProps } from 'react-native';

import { RenderRequestKey } from '../RNIRenderRequestView';
import { OnDidSetListItemEvent } from './RNITableViewCellContentNativeViewEvents';
import { RNITableViewListItem } from '../RNITableView/RNITableViewTypes';


export type RNITableViewCellContentNativeViewBaseProps = {
  listItem: RNITableViewListItem | undefined;
  renderRequestKey: RenderRequestKey;
  onDidSetListItem: OnDidSetListItemEvent;
};

export type RNITableViewCellContentNativeViewProps = 
  RNITableViewCellContentNativeViewBaseProps & ViewProps;