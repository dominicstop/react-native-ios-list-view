import React from 'react';
import { Dimensions, LayoutChangeEvent, StyleSheet, ViewStyle } from 'react-native';

import { RNITableView, RNITableViewListDataItem } from '../../native_components/RNITableView';

import type { TableViewProps, TableViewState } from './TableViewTypes';
import { RNIRenderRequestView } from '../../native_components/RNIRenderRequestView';
import { RNITableViewCellContentView } from '../../native_components/RNITableViewCellContent';


const NATIVE_ID_KEYS = {
  renderRequest: "renderRequest",
};

export class TableView extends 
  React.PureComponent<TableViewProps, TableViewState> {

  nativeRef!: RNITableView;

  constructor(props: TableViewProps){
    super(props);

    this.state = {
      tableViewWidth: Dimensions.get('window').width,
    };
  };

  private getProps = () => {
    const {
      listData,
      listDataKeyExtractor,
      renderCellContent,
      cellContentContainerStyle,
      minimumListCellHeight,
      ...viewProps
    } = this.props;

    const listDataProcessed: Array<RNITableViewListDataItem> = listData.map((item, index) => {
      return ({
        key: listDataKeyExtractor(item, index),
        data: item,
      });
    });

    return {
      // A. Group native props for `RNITableView`...
      nativeProps: {
        listData: listDataProcessed,
        minimumListCellHeight:  
          minimumListCellHeight ?? 100,
      },

      listData,
      renderCellContent,
      cellContentContainerStyle,

      // B. Move all the default view-related
      //    props here...
      viewProps,
    };
  };

  private _handleOnLayout = (event: LayoutChangeEvent) => {
    this.setState({
      tableViewWidth: event.nativeEvent.layout.width,
    });
  };

  // Render
  // -----
  
  render(){
    const props = this.getProps();
    const state = this.state;

    const cellContentContainerStyle: ViewStyle = {
      width: state.tableViewWidth,
      minHeight: props.nativeProps.minimumListCellHeight
    };

    return (
      <RNITableView
        {...props.viewProps}
        {...props.nativeProps}
        ref={r => { this.nativeRef = r! }}
        style={[styles.nativeView, props.viewProps.style]}
        onLayout={this._handleOnLayout}
      >
        <RNIRenderRequestView
          nativeID={NATIVE_ID_KEYS.renderRequest}
          renderItem={(renderRequestData) => {
            return (
              <RNITableViewCellContentView
                key={renderRequestData.renderRequestKey}
                style={[
                  cellContentContainerStyle,
                  props.cellContentContainerStyle,
                ]}
                renderRequestKey={renderRequestData.renderRequestKey}
                renderCellContent={(
                  listDataEntry,
                  orderedListDataEntryIndex,
                  reactListDataEntryIndex,
                ) => {

                  const listDataItem: object | undefined = (() => {
                    if(reactListDataEntryIndex == null) return;
                    return props.listData[reactListDataEntryIndex];
                  })(); 

                  return props.renderCellContent(
                    listDataItem,
                    renderRequestData,
                    orderedListDataEntryIndex,
                    reactListDataEntryIndex,
                  );
                }}
              >
              </RNITableViewCellContentView>
            );
          }}
        />
      </RNITableView>
    );
  };
};

const styles = StyleSheet.create({
  nativeView: {
  },
});