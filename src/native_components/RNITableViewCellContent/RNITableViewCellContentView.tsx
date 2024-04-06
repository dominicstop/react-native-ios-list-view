
import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, Text, View } from 'react-native';

import { RNITableViewCellContentViewProps, RNITableViewCellContentViewState } from './RNITableViewCellContentViewTypes';
import { RNITableViewCellContentNativeView } from './RNITableViewCellContentNativeView';
import { OnDidSetListDataEntryEvent } from './RNITableViewCellContentNativeViewEvents';


export class RNITableViewCellContentView extends React.PureComponent<
  RNITableViewCellContentViewProps,
  RNITableViewCellContentViewState
> {
  
  nativeRef?: View;
  reactTag?: number;

  constructor(props: RNITableViewCellContentViewProps){
    super(props);

    this.state = {
      listDataEntry: undefined,
      orderedListDataEntryIndex: undefined,
      reactListDataEntryIndex: undefined,
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
      renderRequestKey,
      onDidSetListDataEntry,
      renderCellContent,
      ...viewProps
    } = this.props;

    return {
      // A. Group native props
      nativeProps: {
        renderRequestKey,
        onDidSetListDataEntry,
      },
      
      // B: Pass through props...
      renderCellContent,

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

  private _handleOnDidSetListDataEntry: OnDidSetListDataEntryEvent = (event) => {
    const payload = event.nativeEvent;
    
    event.stopPropagation();
    this.props.onDidSetListDataEntry?.(event);

    this.setState({
      listDataEntry: payload.listDataEntry,
      orderedListDataEntryIndex: payload.orderedListDataEntryIndex,
      reactListDataEntryIndex: payload.reactListDataEntryIndex,
    });
  };

  render(){
    const props = this.getProps();
    const state = this.state;

    return React.createElement(RNITableViewCellContentNativeView, {
      ...props.viewProps,
      ...props.nativeProps,
      ...((this.reactTag == null) && {
        onLayout: this._handleOnLayout,
      }),
      // @ts-ignore
      ref: this._handleOnNativeRef,
      style: [
        this.props.style,
        styles.nativeView
      ],
      onDidSetListDataEntry: this._handleOnDidSetListDataEntry,
      children: props.renderCellContent(
        state.listDataEntry,
        state.orderedListDataEntryIndex,
        state.reactListDataEntryIndex,
      ),
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
    position: 'absolute',
  },
});