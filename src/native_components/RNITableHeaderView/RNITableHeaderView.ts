
import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, View, ViewStyle } from 'react-native';

import { CGRectInit } from 'react-native-ios-utilities';

import { RNITableHeaderViewProps } from './RNITableHeaderViewTypes';
import { RNITableHeaderNativeView } from './RNITableHeaderNativeView';
import { RNITableHeaderViewModule } from './RNITableHeaderViewModule';


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

  notifyOnReactLayout = async (rect: CGRectInit) => {
    const reactTag = this.getNativeReactTag();
    if(typeof reactTag !== 'number') return;

    await RNITableHeaderViewModule.notifyOnReactLayout(reactTag, {
      layoutRect: rect,
    });
  };

  // Event Handlers
  // --------------

  private _handleOnLayout = ({nativeEvent}: LayoutChangeEvent) => {
    if(this.reactTag == null){
      // @ts-ignore
      this.reactTag = nativeEvent.target;
    };
    
    this.notifyOnReactLayout({
      height: nativeEvent.layout.height,
      width: nativeEvent.layout.width,
      x: nativeEvent.layout.x,
      y: nativeEvent.layout.y,
    });

    console.log(
      "RNITableHeaderView._handleOnLayout",
      "\n - height:", nativeEvent.layout.height,
      "\n - width:", nativeEvent.layout.width,
      "\n - x:", nativeEvent.layout.x,
      "\n - y:", nativeEvent.layout.y,
      "\n "
    );
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