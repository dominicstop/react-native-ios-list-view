import React from 'react';
import { Dimensions, LayoutChangeEvent, StyleSheet, ViewStyle } from 'react-native';

import type { TableViewProps, TableViewState } from './TableViewTypes';

import { RNITableView, RNITableViewListItem, RNITableViewListItemMoveOperationConfig } from '../../native_components/RNITableView';
import { RNITableViewCellContentView } from '../../native_components/RNITableViewCellContent';
import { RNITableHeaderView } from '../../native_components/RNITableHeaderView';

import { RNIRenderRequestView, RenderRequestItem } from '../../native_components/RNIRenderRequestView';


const NATIVE_ID_KEYS = {
  renderRequest: "renderRequest",
  listHeader: "listHeader",
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
      cellContentContainerStyle,
      minimumListCellHeight,
      initialCellsToRenderCount,
      tableHeaderContainerStyle,

      listDataKeyExtractor,
      renderCellContent,
      renderListHeader,
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

      // B. Pass-through props...
      listData,
      cellContentContainerStyle,
      tableHeaderContainerStyle,
      renderCellContent,
      renderListHeader,
    
      // C. Props w/ default
      initialCellsToRenderCount: initialCellsToRenderCountWithDefault,

      // D. Move all the default view-related
      //    props here...
      viewProps,
    };
  };

  private _handleOnLayout = (event: LayoutChangeEvent) => {
    this.setState({
      tableViewWidth: event.nativeEvent.layout.width,
    });
  };

  // Public Functions
  // ----------------

  requestToMoveListItem = async (
    config: RNITableViewListItemMoveOperationConfig
  ) => {
    this.nativeRef.requestToMoveListItem(config);
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

    const shouldRenderListHeader = props.renderCellContent != null;

    return (
      <RNITableView
        {...props.viewProps}
        {...props.nativeProps}
        ref={r => { this.nativeRef = r! }}
        style={[styles.nativeView, props.viewProps.style]}
        onLayout={this._handleOnLayout}
      >
        {shouldRenderListHeader && (
          <RNITableHeaderView
            nativeID={NATIVE_ID_KEYS.listHeader}
            style={props.tableHeaderContainerStyle}
          >
            {props.renderListHeader?.()}
          </RNITableHeaderView>
        )}
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
                  nativeListItem,
                  orderedListItemIndex,
                  reactListItemIndex,
                ) => {

                  const listDataItem: object | undefined = (() => {
                    if(reactListItemIndex == null) return;
                    return props.listData[reactListItemIndex];
                  })(); 

                  return props.renderCellContent(
                    // NOTE: This assumes that `renderRequestKey` == `listData` order.
                    // This might not always be true though
                    listDataItem ?? props.listData[renderRequestData.renderRequestKey],
                    renderRequestData,
                    orderedListItemIndex ?? renderRequestData.renderRequestKey,
                    reactListItemIndex ?? renderRequestData.renderRequestKey,
                    nativeListItem,
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