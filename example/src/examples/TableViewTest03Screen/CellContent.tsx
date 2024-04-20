import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, ViewStyle } from 'react-native';

import { TableView, TableViewCustomReorderControlWrapper, TableViewNativeListItem} from 'react-native-ios-list-view';

import * as Helpers from '../../functions/Helpers';
import * as Colors from '../../constants/Colors';

import { ListDataItem, ListReorderPresetItem } from './Constants';
import { RNIImageView } from 'react-native-ios-utilities';


export function CellContent(props: {
  tableViewRef:  React.RefObject<TableView>;
  reuseIdentifier: number;
  listDataItem: ListDataItem | undefined;
  orderedListItemIndex: number | undefined;
  reactListItemIndex: number | undefined;
  nativeListItem: TableViewNativeListItem | undefined;
  listDataCount: number;
  reorderPresetItem: ListReorderPresetItem;
}){

  const listIndex = props.reactListItemIndex ?? 0;

  const listIndexPrefix = (() => {
    const index = `${listIndex + 1}`;

    if(index.length == 1){
      return `000`;
    };

    if(index.length == 2){
      return `00`;
    };

    if(index.length == 3){
      return `0`;
    };

    return "";
  })();

  const rootContainerStyle: ViewStyle = {
    backgroundColor: props.listDataItem?.colorHex,
  };

  const isEditingConfig = 
    props.reorderPresetItem.props.isEditingConfig;

  const rightButtonsContainerStyle: ViewStyle = {
    opacity: (() => {
      if(isEditingConfig == null) return 1;

      return isEditingConfig.defaultReorderControlMode == 'visible'
        ? 0
        : 1;
    })(),
  };

  return (
    <View style={[
      styles.rootContainer,
      rootContainerStyle,
    ]}>
      <View style={[
        styles.columnButtonContainer,
        styles.leftButtonsContainer,
      ]}>
        <TouchableOpacity
          style={[
            styles.moveButton,
            styles.moveUpButton,
          ]}
          onPress={() => {
            const tableViewRef = props.tableViewRef?.current;
            if(tableViewRef == null) return;

            const keyForItem = props.nativeListItem?.key;
            if(keyForItem == null) return;

            tableViewRef?.requestToMoveListItem({
              mode: 'moveUp',
              numberOfPlaces: 1,
              sourceConfig: {
                mode: 'matchingKey',
                key: keyForItem,
              },
              shouldAnimateDifference: true,
            });
          }}
        >
          <RNIImageView
            style={styles.moveButtonIcon}
            imageConfig={{
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'chevron.up',
                weight: 'bold',
              },
              imageOptions: {
                tint: 'white',
                renderingMode: 'alwaysOriginal',
              },
            }}
          />
        </TouchableOpacity>
        <TouchableOpacity
          style={[
            styles.moveButton,
            styles.moveDownButton,
          ]}
          onPress={() => {
            const tableViewRef = props.tableViewRef?.current;
            if(tableViewRef == null) return;

            const keyForItem = props.nativeListItem?.key;
            if(keyForItem == null) return;

            tableViewRef?.requestToMoveListItem({
              mode: 'moveDown',
              numberOfPlaces: 1,
              sourceConfig: {
                mode: 'matchingKey',
                key: keyForItem,
              },
              shouldAnimateDifference: true,
            });
          }}
        >
          <RNIImageView
            style={styles.moveButtonIcon}
            imageConfig={{
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'chevron.down',
                weight: 'bold',
              },
              imageOptions: {
                tint: 'white',
                renderingMode: 'alwaysOriginal',
              },
            }}
          />
        </TouchableOpacity>
      </View>
      <TableViewCustomReorderControlWrapper>
        <View style={styles.middleOuterContainer}>
          <View style={styles.middleInnerContainer}>
            <View style={styles.middleTopContainer}>
                <Text style={styles.indexText}>
                  {`${listIndexPrefix + listIndex}`}
                </Text>
                <Text style={styles.colorNameText}>
                  {props.listDataItem?.colorName ?? "N/A"}
                </Text>
              </View>
              <View style={styles.middleBottomContainer}>
                <Text style={styles.colorHexText}>
                  {props.listDataItem?.colorHex ?? "N/A"}
                </Text>
              </View>
          </View>
      </View>
      </TableViewCustomReorderControlWrapper>
      <View 
        style={[
          styles.columnButtonContainer,
          styles.rightButtonsContainer,
          rightButtonsContainerStyle,
        ]}
      >
        <TouchableOpacity
          style={styles.rightButton}
          onPress={() => {
          }}
        >
          <RNIImageView
            style={styles.rightButtonIcon}
            imageConfig={{
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'doc.on.doc.fill',
                weight: 'bold',
              },
              imageOptions: {
                tint: 'white',
                renderingMode: 'alwaysOriginal',
              },
            }}
          />
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.rightButton}
          onPress={() => {
          }}
        >
          <RNIImageView
            style={styles.rightButtonIcon}
            imageConfig={{
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'trash.fill',
                weight: 'bold',
              },
              imageOptions: {
                tint: 'white',
                renderingMode: 'alwaysOriginal',
              },
            }}
          />
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
    paddingHorizontal: 12,
    paddingVertical: 10,
    flexDirection: 'row',
  },
  spacer: {
    marginBottom: 10,
  },
  leftButtonsContainer: {
    alignSelf: 'stretch',
  },
  columnButtonContainer: {
    width: 42,
  },
  moveButton: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(0,0,0,0.15)',
    paddingVertical: 6,
  },
  moveButtonIcon: {
    width: 25,
    height: 25,
    opacity: 0.75,
  },
  moveUpButton: {
    borderTopLeftRadius: 10,
    borderTopRightRadius: 10,
    borderBottomColor: 'rgba(255,255,255,0.1)',
    borderBottomWidth: 3,
  },
  moveDownButton: {
    borderBottomLeftRadius: 10,
    borderBottomRightRadius: 10,
  },
  middleOuterContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  middleInnerContainer: {
  },
  middleTopContainer: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    marginBottom: -6,
  },
  middleBottomContainer: {
  },
  colorNameText: {
    color: 'rgba(255,255,255,0.6)',
    fontSize: 22,
    fontWeight: '800',
    letterSpacing: 1.5,
    marginLeft: 7,
  },
  colorHexText: {
    color: 'rgba(255,255,255,0.85)',
    fontSize: 52,
    fontWeight: '800',
    letterSpacing: 2.75,
  },
  indexText: {
    color: 'rgba(255,255,255,0.5)',
    fontSize: 21,
    fontWeight: '500',
    letterSpacing: 1.8,
    fontVariant: ['tabular-nums'],
    textDecorationLine: 'underline',
    textDecorationColor: 'rgba(255,255,255,0.2)',
  },
  rightButtonsContainer: {
  },
  rightButton: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 7,
  },
  rightButtonIcon: {
    width: 23,
    height: 23,
    opacity: 0.6,
  },
});