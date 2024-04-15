import * as React from 'react';
import { ViewProps } from 'react-native';

import { RNITableViewCellContentNativeViewBaseProps } from './RNITableViewCellContentNativeViewTypes';
import { OnDidSetListItemEventPayload } from './RNITableViewCellContentNativeViewEvents';
import { RNITableViewProps } from '../RNITableView/RNITableViewTypes';


type InheritedNativeRequiredProps = Pick<
  RNITableViewCellContentNativeViewBaseProps,
  | 'renderRequestKey'
>;

type InheritedNativeOptionalProps = Partial<Pick<
  RNITableViewCellContentNativeViewBaseProps,
  | 'onDidSetListItem'
>>;

type InheritedNativeProps = 
  & InheritedNativeRequiredProps
  & InheritedNativeOptionalProps;

type InheritedPropsFromRNITableView = Pick<
  RNITableViewProps,
  | 'minimumListCellHeight'
>;

export type RNITableViewCellContentViewInheritedProps = 
  & InheritedNativeProps
  & InheritedPropsFromRNITableView;

export type RenderTableViewCellContentView = (
  listItem: 
    RNITableViewCellContentViewState['listItem'],

  orderedListItemIndex: 
    RNITableViewCellContentViewState['orderedListItemIndex'],

  reactListItemIndex: 
    RNITableViewCellContentViewState['reactListItemIndex'],
) => React.ReactElement;

export type RNITableViewCellContentViewBaseProps = {
  renderCellContent: RenderTableViewCellContentView;
};

export type RNITableViewCellContentViewProps = 
    RNITableViewCellContentViewBaseProps 
  & RNITableViewCellContentViewInheritedProps
  & ViewProps;

export type RNITableViewCellContentViewState = {
  renderCounter: number;

  listItem: 
    | OnDidSetListItemEventPayload['listItem'] 
    | undefined;

  orderedListItemIndex: 
    | OnDidSetListItemEventPayload['orderedListItemIndex'] 
    | undefined;

  reactListItemIndex: 
    | OnDidSetListItemEventPayload['reactListItemIndex'] 
    | undefined;
};