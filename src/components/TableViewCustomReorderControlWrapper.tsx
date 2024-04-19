
import React from 'react';
import { ViewProps } from 'react-native';
import { TABLE_VIEW_NATIVE_ID_KEYS } from './TableView/Constants';

export function TableViewCustomReorderControlWrapper(props: {
  children: JSX.Element;
}) {
  React.cloneElement(props.children as React.ReactElement<ViewProps>, {
    nativeID: TABLE_VIEW_NATIVE_ID_KEYS.customReorderControl,
  });
};