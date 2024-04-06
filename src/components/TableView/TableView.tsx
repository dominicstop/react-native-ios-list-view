import React from 'react';
import { StyleSheet } from 'react-native';

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
    };
  };

  private getProps = () => {
    const {
      listData,
      listDataKeyExtractor,
      renderCellContent,
      cellContentContainerStyle,
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
      },

      listData,
      renderCellContent,
      cellContentContainerStyle,

      // B. Move all the default view-related
      //    props here...
      viewProps,
    };
  };

  // Render
  // -----
  
  render(){
    const props = this.getProps();
    const state = this.state;

    return (
      <RNITableView
        {...props.viewProps}
        {...props.nativeProps}
        ref={r => { this.nativeRef = r! }}
        style={[styles.nativeView, props.viewProps.style]}
      >
        <RNIRenderRequestView
          nativeID={NATIVE_ID_KEYS.renderRequest}
          renderItem={(renderRequestData) => {
            return (
              <RNITableViewCellContentView
                key={renderRequestData.renderRequestKey}
                style={props.cellContentContainerStyle}
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