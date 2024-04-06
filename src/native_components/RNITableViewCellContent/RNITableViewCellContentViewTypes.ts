import * as React from 'react';
import { ViewProps } from 'react-native';

import { RNITableViewCellContentNativeViewBaseProps } from './RNITableViewCellContentNativeViewTypes';
import { OnDidSetListDataEntryEventPayload } from './RNITableViewCellContentNativeViewEvents';


export type RNITableViewCellContentViewInheritedRequiredProps = Pick<RNITableViewCellContentNativeViewBaseProps,
 | 'renderRequestKey'
>;

export type RNITableViewCellContentViewInheritedOptionalProps = Partial<Pick<RNITableViewCellContentNativeViewBaseProps,
 | 'onDidSetListDataEntry'
>>;

export type RNITableViewCellContentViewInheritedProps = 
  & RNITableViewCellContentViewInheritedRequiredProps
  & RNITableViewCellContentViewInheritedOptionalProps;

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