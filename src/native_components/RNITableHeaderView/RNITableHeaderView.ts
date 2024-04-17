
import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, View, ViewStyle } from 'react-native';

import { RNITableHeaderViewProps } from './RNITableHeaderViewTypes';
import { RNITableHeaderNativeView } from './RNITableHeaderNativeView';


export class RNITableHeaderView extends React.PureComponent<RNITableHeaderViewProps> {
  
  nativeRef?: View;
  reactTag?: number;

  constructor(props: RNITableHeaderViewProps){
    super(props);

    this.state = {
      renderCounter: 0,

      listItem: undefined,
      orderedListItemIndex: undefined,
      reactListItemIndex: undefined,
    };
  };

  getNativeRef: () => View | undefined = () => {
    return this.nativeRef;
  };

  getNativeReactTag: () => number | undefined = () => {
    // @ts-ignore
    return this.nativeRef?.nativeTag ?? this.reactTag
  };
  
  private getProps = () => {
    const {
      ...viewProps
    } = this.props;

    return {
      // A. Group native props
      nativeProps: {
      },
      
      viewProps,
    };
  };

  // Event Handlers
  // --------------

  private _handleOnLayout = ({nativeEvent}: LayoutChangeEvent) => {
    if(this.reactTag != null) return;
    if(nativeEvent['target'] == null) return;

    // @ts-ignore
    this.reactTag = nativeEvent.target;
  };

  private _handleOnNativeRef = (ref: View) => {
    this.nativeRef = ref;
  };

  render(){
    const props = this.getProps();
    const state = this.state;

    return React.createElement(RNITableHeaderNativeView, {
      ...props.viewProps,
      ...props.nativeProps,
      ...((this.reactTag == null) && {
        onLayout: this._handleOnLayout,
      }),
      onLayout: this._handleOnLayout,
      // @ts-ignore
      ref: this._handleOnNativeRef,
      style: [
        this.props.style,
        styles.nativeView,
      ],
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
    position: 'absolute',
  },
});