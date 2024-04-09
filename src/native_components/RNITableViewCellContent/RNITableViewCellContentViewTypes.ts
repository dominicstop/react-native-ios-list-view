import * as React from 'react';
import { ViewProps } from 'react-native';

import { RNITableViewCellContentNativeViewBaseProps } from './RNITableViewCellContentNativeViewTypes';
import { OnDidSetListDataEntryEventPayload } from './RNITableViewCellContentNativeViewEvents';
import { RNITableViewProps } from '../RNITableView/RNITableViewTypes';


type InheritedNativeRequiredProps = Pick<
  RNITableViewCellContentNativeViewBaseProps,
  | 'renderRequestKey'
>;

type InheritedNativeOptionalProps = Partial<Pick<
  RNITableViewCellContentNativeViewBaseProps,
  | 'onDidSetListDataEntry'
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
  listDataEntry: 
    RNITableViewCellContentViewState['listDataEntry'],

  orderedListDataEntryIndex: 
    RNITableViewCellContentViewState['orderedListDataEntryIndex'],

  reactListDataEntryIndex: 
    RNITableViewCellContentViewState['reactListDataEntryIndex'],
) => React.ReactElement;

export type RNITableViewCellContentViewBaseProps = {
  renderCellContent: RenderTableViewCellContentView;
};

export type RNITableViewCellContentViewProps = 
    RNITableViewCellContentViewBaseProps 
  & RNITableViewCellContentViewInheritedProps
  & ViewProps;

export type RNITableViewCellContentViewState = {
  listDataEntry: 
    | OnDidSetListDataEntryEventPayload['listDataEntry'] 
    | undefined;

  orderedListDataEntryIndex: 
    | OnDidSetListDataEntryEventPayload['orderedListDataEntryIndex'] 
    | undefined;

  reactListDataEntryIndex: 
    | OnDidSetListDataEntryEventPayload['reactListDataEntryIndex'] 
    | undefined;
};