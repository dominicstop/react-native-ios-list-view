
import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, View } from 'react-native';

import { RNITableViewProps } from './RNITableViewTypes';
import { RNITableNativeView } from './RNITableNativeView';


export class RNITableView extends React.PureComponent<RNITableViewProps> {
  
  nativeRef?: View;
  reactTag?: number;

  constructor(props: RNITableViewProps){
    super(props);
  };

  getNativeRef: () => View | undefined = () => {
    return this.nativeRef;
  };

  getNativeReactTag: () => number | undefined = () => {
    // @ts-ignore
    return this.nativeRef?.nativeTag ?? this.reactTag
  };


  // Event Handlers
  // --------------

  private _handleOnLayout = (event: LayoutChangeEvent) => {
    this.props.onLayout?.(event);

    // @ts-ignore
    this.reactTag = event.nativeEvent.target;
  };

  private _handleOnNativeRef = (ref: View) => {
    this.nativeRef = ref;
  };

  render(){
    return React.createElement(RNITableNativeView, {
      ...this.props,
      ...((this.reactTag == null) && {
        onLayout: this._handleOnLayout,
      }),
      // @ts-ignore
      ref: this._handleOnNativeRef,
      style: [
        this.props.style,
        styles.nativeView
      ],
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
  },
});