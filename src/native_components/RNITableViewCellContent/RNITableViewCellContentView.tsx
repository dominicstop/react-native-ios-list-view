
import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, View, ViewStyle } from 'react-native';

import { CGRectInit } from 'react-native-ios-utilities';

import { RNITableViewCellContentViewProps, RNITableViewCellContentViewState } from './RNITableViewCellContentViewTypes';
import { RNITableViewCellContentNativeView } from './RNITableViewCellContentNativeView';
import { OnDidSetListDataEntryEvent } from './RNITableViewCellContentNativeViewEvents';
import { RNITableViewCellContentViewModule } from './RNITableViewCellContentViewModule';


export class RNITableViewCellContentView extends React.PureComponent<
  RNITableViewCellContentViewProps,
  RNITableViewCellContentViewState
> {
  
  nativeRef?: View;
  reactTag?: number;

  constructor(props: RNITableViewCellContentViewProps){
    super(props);

    this.state = {
      renderCounter: 0,

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
      minimumListCellHeight,
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
      minimumListCellHeight,
      renderCellContent,

      // C. Move all the default view-related
      //    props here...
      viewProps,
    };
  };

  notifyOnReactLayout = async (rect: CGRectInit) => {
    const reactTag = this.getNativeReactTag();
    if(typeof reactTag !== 'number') return;

    await RNITableViewCellContentViewModule.notifyOnReactLayout(reactTag, {
      layoutRect: rect,
      renderRequestKey: this.props.renderRequestKey,
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
      "RNITableViewCellContentView._handleOnLayout",
      "\n - listDataEntry.key:", this.state.listDataEntry?.key ?? -1,
      "\n - orderedListDataEntryIndex:", this.state.orderedListDataEntryIndex ?? -1,
      "\n - reactListDataEntryIndex:", this.state.reactListDataEntryIndex ?? -1,
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

  private _handleOnDidSetListDataEntry: OnDidSetListDataEntryEvent = (event) => {
    const payload = event.nativeEvent;
    
    event.stopPropagation();
    this.props.onDidSetListDataEntry?.(event);

    this.setState((prevState) => ({
      ...prevState,
      renderCounter: prevState.renderCounter + 1,
      listDataEntry: payload.listDataEntry,
      orderedListDataEntryIndex: payload.orderedListDataEntryIndex,
      reactListDataEntryIndex: payload.reactListDataEntryIndex,
    }));

    console.log(
      "RNITableViewCellContentView._handleOnDidSetListDataEntry",
      "\n - listDataEntry:", payload.listDataEntry,
      "\n - orderedListDataEntryIndex:", payload.orderedListDataEntryIndex,
      "\n - reactListDataEntryIndex:", payload.reactListDataEntryIndex,
      "\n "
    );
  };

  render(){
    const props = this.getProps();
    const state = this.state;

    const nativeViewStyle: ViewStyle = {
      minHeight: props.minimumListCellHeight
    };

    return React.createElement(RNITableViewCellContentNativeView, {
      ...props.viewProps,
      ...props.nativeProps,
      ...((this.reactTag == null) && {
      }),
      onLayout: this._handleOnLayout,
      // @ts-ignore
      ref: this._handleOnNativeRef,
      style: [
        nativeViewStyle,
        this.props.style,
        styles.nativeView,
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