import React from 'react';
import { Dimensions, LayoutChangeEvent, StyleSheet, View, Text, ViewStyle } from 'react-native';

import { RNITableView, RNITableViewListItem } from '../../native_components/RNITableView';

import type { TableViewProps, TableViewState } from './TableViewTypes';
import { RNIRenderRequestView, RenderRequestItem } from '../../native_components/RNIRenderRequestView';
import { RNITableViewCellContentView } from '../../native_components/RNITableViewCellContent';


const NATIVE_ID_KEYS = {
  renderRequest: "renderRequest",
};

const WINDOW_SIZE = Dimensions.get('window');

export class TableView extends 
  React.PureComponent<TableViewProps, TableViewState> {

  nativeRef!: RNITableView;

  constructor(props: TableViewProps){
    super(props);

    this.state = {
      tableViewWidth: WINDOW_SIZE.width,
    };
  };

  private getProps = () => {
    const {
      listData,
      listDataKeyExtractor,
      renderCellContent,
      cellContentContainerStyle,
      minimumListCellHeight,
      initialCellsToRenderCount,
      ...viewProps
    } = this.props;

    const listDataProcessed: Array<RNITableViewListItem> = listData.map((item, index) => {
      return ({
        key: listDataKeyExtractor(item, index),
        data: item,
      });
    });

    const minimumListCellHeightDefault = minimumListCellHeight ?? 100;
    
    const initialCellsToRenderCountWithDefault = (() => {
      if(initialCellsToRenderCount != null){
        return initialCellsToRenderCount;
      };

      const base = Math.ceil(WINDOW_SIZE.height / minimumListCellHeightDefault);
      const baseAdj = base + 3;

      return Math.max(baseAdj, 6);
    })();

    return {
      // A. Group native props for `RNITableView`...
      nativeProps: {
        listData: listDataProcessed,
        minimumListCellHeight: minimumListCellHeightDefault,
      },

      listData,
      renderCellContent,
      cellContentContainerStyle,
      initialCellsToRenderCount: initialCellsToRenderCountWithDefault,

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

    const initialRenderRequestItems = (() => {
      const items: Array<RenderRequestItem> = [];
      
      for(let index = 0; index < props.initialCellsToRenderCount; index++){
        items.push({ renderRequestKey: index });
      };

      return items;
    })();

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
          initialRenderRequestItems={initialRenderRequestItems}
          renderItem={(renderRequestData) => {
            return (
              <RNITableViewCellContentView
                key={renderRequestData.renderRequestKey}
                minimumListCellHeight={props.nativeProps.minimumListCellHeight}
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
                    // NOTE: This assumes that `renderRequestKey` == `listData` order.
                    // This might not always be true though
                    listDataItem ?? props.listData[renderRequestData.renderRequestKey],
                    renderRequestData,
                    orderedListDataEntryIndex ?? renderRequestData.renderRequestKey,
                    reactListDataEntryIndex ?? renderRequestData.renderRequestKey,
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