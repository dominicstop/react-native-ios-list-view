import * as React from 'react';
import { StyleSheet, View } from 'react-native';

import { TableView } from 'react-native-ios-list-view';

import { CELL_HEIGHT, DUMMY_LIST_DATA, ListDataItem, ListReorderPresets } from './Constants';
import { CellContent } from './CellContent';
import { ListHeader } from './ListHeader';


export function TableViewTest03Screen() {
  const [listData, setListData] = React.useState(DUMMY_LIST_DATA);
  const tableViewRef = React.useRef<TableView>(null);

  const [
    reorderPresetCounter, 
    setReorderPresetCounter
  ] = React.useState(0);

  const reorderPresetIndex = 
    reorderPresetCounter % ListReorderPresets.length;

  const reorderPresetItem = 
    ListReorderPresets[reorderPresetIndex];

  return (
    <View style={styles.rootContainer}>
      <TableView
        {...reorderPresetItem.props}
        ref={tableViewRef}
        style={styles.tableView}
        listData={listData}
        minimumListCellHeight={CELL_HEIGHT}
        listDataKeyExtractor={(
          item: Record<string, ListDataItem>, 
          index: number
        ) => {
          return `${item.indexID}`;
        }}
        renderListHeader={() => {
          return (
            <ListHeader
              listDataCount={listData.length}
              reorderPresetItem={reorderPresetItem}
              reorderPresetIndex={reorderPresetIndex}
              onPressNextReorderPresetButton={() => {
                setReorderPresetCounter(prevValue => prevValue + 1);
              }}
            />
          );
        }}
        renderCellContent={(
          listDataItem,
          renderRequestData,
          orderedListItemIndex,
          reactListItemIndex,
          nativeListItem,
        ) => {
          return (
            <CellContent
              tableViewRef={tableViewRef}
              listDataCount={DUMMY_LIST_DATA.length}
              reuseIdentifier={renderRequestData.renderRequestKey}
              listDataItem={listDataItem}
              orderedListItemIndex={orderedListItemIndex}
              reactListItemIndex={reactListItemIndex}
              nativeListItem={nativeListItem}
              reorderPresetItem={reorderPresetItem}
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

