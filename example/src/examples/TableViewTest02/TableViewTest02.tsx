import * as React from 'react';
import { StyleSheet, View } from 'react-native';

import { TableView } from 'react-native-ios-list-view';

import { DUMMY_LIST_DATA, ListDataItem } from './Constants';
import { CellContent } from './CellContent';

import * as Helpers from '../../functions/Helpers';

export function TableViewTest02Screen() {
  return (
    <View style={styles.rootContainer}>
      <TableView
        style={styles.tableView}
        listData={DUMMY_LIST_DATA}
        minimumListCellHeight={100}
        dragInteractionEnabled={true}
        listDataKeyExtractor={(
          item: Record<string, ListDataItem>, 
          index: number
        ) => {
          return `${item.indexID}`;
        }}
        renderCellContent={(
          listDataItem,
          renderRequestData,
          orderedListItemIndex,
          reactListItemIndex,
        ) => {
          return (
            <CellContent
              listDataCount={DUMMY_LIST_DATA.length}
              reuseIdentifier={renderRequestData.renderRequestKey}
              listDataItem={listDataItem}
              orderedListItemIndex={orderedListItemIndex}
              reactListItemIndex={reactListItemIndex}
            />
          );
        }}
      />
    </View>
  );
};


const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
    backgroundColor: '#fff',
  },
  tableView: {
    flex: 1,
  },
});

