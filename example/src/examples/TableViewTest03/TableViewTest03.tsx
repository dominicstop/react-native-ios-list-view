import * as React from 'react';
import { StyleSheet, View } from 'react-native';

import { TableView } from 'react-native-ios-list-view';

import { CELL_HEIGHT, DUMMY_LIST_DATA, ListDataItem } from './Constants';
import { CellContent } from './CellContent';


export function TableViewTest03Screen() {
  return (
    <View style={styles.rootContainer}>
      <TableView
        style={styles.tableView}
        listData={DUMMY_LIST_DATA}
        minimumListCellHeight={CELL_HEIGHT}
        listDataKeyExtractor={(
          item: Record<string, ListDataItem>, 
          index: number
        ) => {
          return `${item.indexID}`;
        }}
        renderCellContent={(
          listDataItem,
          renderRequestData,
          orderedListDataEntryIndex,
          reactListDataEntryIndex,
        ) => {
          return (
            <CellContent
              listDataCount={DUMMY_LIST_DATA.length}
              reuseIdentifier={renderRequestData.renderRequestKey}
              listDataItem={listDataItem}
              orderedListDataEntryIndex={orderedListDataEntryIndex}
              reactListDataEntryIndex={reactListDataEntryIndex}
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

