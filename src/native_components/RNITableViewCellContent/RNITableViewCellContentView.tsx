
import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, View, ViewStyle } from 'react-native';

import { CGRectInit } from 'react-native-ios-utilities';

import { RNITableViewCellContentViewProps, RNITableViewCellContentViewState } from './RNITableViewCellContentViewTypes';
import { RNITableViewCellContentNativeView } from './RNITableViewCellContentNativeView';
import { OnDidSetListItemEvent } from './RNITableViewCellContentNativeViewEvents';
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
      renderRequestKey,
      minimumListCellHeight,
      onDidSetListItem,
      renderCellContent,
      ...viewProps
    } = this.props;

    return {
      // A. Group native props
      nativeProps: {
        renderRequestKey,
        onDidSetListItem,
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
      "\n - listItem.key:", this.state.listItem?.key ?? -1,
      "\n - orderedListItemIndex:", this.state.orderedListItemIndex ?? -1,
      "\n - reactListItemIndex:", this.state.reactListItemIndex ?? -1,
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

  private _handleOnDidSetListItem: OnDidSetListItemEvent = (event) => {
    const payload = event.nativeEvent;
    
    event.stopPropagation();
    this.props.onDidSetListItem?.(event);

    this.setState((prevState) => ({
      ...prevState,
      renderCounter: prevState.renderCounter + 1,
      listItem: payload.listItem,
      orderedListItemIndex: payload.orderedListItemIndex,
      reactListItemIndex: payload.reactListItemIndex,
    }));

    console.log(
      "RNITableViewCellContentView._handleOnDidSetListItem",
      "\n - listItem:", payload.listItem,
      "\n - orderedListItemIndex:", payload.orderedListItemIndex,
      "\n - reactListItemIndex:", payload.reactListItemIndex,
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
      listItem: state.listItem,
      onDidSetListItem: this._handleOnDidSetListItem,
      children: props.renderCellContent(
        state.listItem,
        state.orderedListItemIndex,
        state.reactListItemIndex,
      ),
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
    position: 'absolute',
  },
});