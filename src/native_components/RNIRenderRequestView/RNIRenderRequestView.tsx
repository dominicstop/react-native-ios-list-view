
import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, Text, View } from 'react-native';

import { RNIRenderRequestViewProps, RNIRenderRequestViewState } from './RNIRenderRequestViewTypes';
import { RNIRenderRequestNativeView } from './RNIRenderRequestNativeView';
import { OnRenderRequestEvent } from './RNIRenderRequestNativeViewEvents';


export class RNIRenderRequestView extends React.PureComponent<
  RNIRenderRequestViewProps,
  RNIRenderRequestViewState
> {
  
  nativeRef?: View;
  reactTag?: number;

  constructor(props: RNIRenderRequestViewProps){
    super(props);

    this.state = {
      renderRequests: [],
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
      renderItem,
      ...viewProps
    } = this.props;

    return {
      // A. Group native props
      nativeProps: {
      },

      // B. React props...
      renderItem,

      // C. Move all the default view-related
      //    props here...
      viewProps,
    };
  };

  // Event Handlers
  // --------------

  private _handleOnLayout = ({nativeEvent}: LayoutChangeEvent) => {
    // @ts-ignore
    this.reactTag = nativeEvent.target;
  };

  private _handleOnNativeRef = (ref: View) => {
    this.nativeRef = ref;
  };

  private _handleOnRenderRequest: OnRenderRequestEvent = ({nativeEvent}) => {
    console.log(
      "_handleOnRenderRequest",
      "renderRequestKey:", nativeEvent.renderRequestKey
    );

    this.setState((prevState) => ({
      ...prevState,
      renderRequests: [
        ...prevState.renderRequests,
        {
          renderRequestKey: nativeEvent.renderRequestKey
        },
      ],
    }));
  };

  render(){
    const props = this.getProps();
    const state = this.state;

    return React.createElement(RNIRenderRequestNativeView, {
      ...props.viewProps,
      ...((this.reactTag == null) && {
        onLayout: this._handleOnLayout,
      }),
      // @ts-ignore
      ref: this._handleOnNativeRef,
      style: [
        this.props.style,
        styles.nativeView
      ],
      onRenderRequest: this._handleOnRenderRequest,
      children: state.renderRequests.map((item, index) => {
        return props.renderItem(item, index);
      }),
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
    position: 'absolute',
  },
});