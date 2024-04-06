import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, ViewStyle } from 'react-native';

import { TableView } from 'react-native-ios-list-view';

import * as Helpers from './src/functions/Helpers';


const LIST_DATA = (() => {
  const items = [];

  for(let index = 0; index < 100; index++){
    items.push({
      indexID: index,
      message: `Hello ${index}`,
    });
  };

  return items;
})();

const DELAY_PRESETS_MS = [
  200,
  400,
  600,
  800,
  1000,
  1200,
  1400,
];

const MIN_CELL_HEIGHT = 100;

type ListDataItem = typeof LIST_DATA[number];

function CellContent(props: {
  reuseIdentifier: number;
  listDataItem: ListDataItem | undefined;
  orderedListDataEntryIndex: number | undefined;
  reactListDataEntryIndex: number | undefined;
}){
  const [counter, setCounter] = React.useState(props.reuseIdentifier);
  const [isIntervalActive, setIsIntervalActive] = React.useState(true);

  const intervalRef = React.useRef<NodeJS.Timeout | undefined>();
  
  const intervalDelayMS = Helpers.getItemFromCyclicArray(
    DELAY_PRESETS_MS, 
    props.reuseIdentifier
  );

  React.useEffect(() => {
    if(!isIntervalActive) return;

    const intervalID = setInterval(() => {
      setCounter((prevValue) => prevValue + 1); 
    }, intervalDelayMS);

    intervalRef.current = intervalID;
    return () => {
      clearTimeout(intervalID);
    };
  }, []);

  const timerColor = isIntervalActive
    ? 'rgba(255,0,0,0.1)'
    : 'rgba(0,255,0,0.1)';

  const timerButtonStyle: ViewStyle = {
    backgroundColor: timerColor,
  };
  
  return (
    <View style={styles.cellContentContainer}>
      <View style={[styles.buttonRowContainer, styles.spacer]}>
        <TouchableOpacity
          style={[
            styles.button, 
            styles.timerButton,
            timerButtonStyle, 
          ]}
          onPress={() => {
            if(isIntervalActive){
              clearTimeout(intervalRef.current!);
              setIsIntervalActive(false);

            } else {
              const intervalID = setInterval(() => {
                setCounter((prevValue) => prevValue + 1); 
              }, intervalDelayMS);

              intervalRef.current = intervalID;
              setIsIntervalActive(true);
            };
          }}
        >
          <Text style={styles.buttonLabel}>
            {isIntervalActive 
              ? 'End Counter' 
              : 'Start Counter'
            } 
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.button, styles.resetTimerButton]}
          onPress={() => {
            setCounter(0);
          }}
        >
          <Text style={styles.buttonLabel}>
            {"Reset Counter"}
          </Text>
        </TouchableOpacity>
      </View>
      <Text style={styles.label}>
        {`Reuse Identifier: ${props.reuseIdentifier}`}
        {' - '}
        {`Counter: ${counter}`}
      </Text>
      <Text style={styles.label}>
        {`indexID: ${props.listDataItem?.indexID ?? '-1'}`}
        {' - '}
        {`message: ${props.listDataItem?.message ?? 'N/A'}`}
      </Text>
      <Text style={styles.label}>
        {`orderedIndex: ${props.orderedListDataEntryIndex ?? '-1'}`}
        {' - '}
        {`listIndex: ${props.reactListDataEntryIndex ?? '-1'}`}
      </Text>
    </View>
  );
};

export default function App() {
  return (
    <View style={styles.container}>
      <TableView
        style={styles.tableView}
        listData={LIST_DATA}
        minimumListCellHeight={MIN_CELL_HEIGHT}
        listDataKeyExtractor={(
          item: Record<string, typeof LIST_DATA[number]>, 
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
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  tableView: {
    flex: 1,
  },
  cellContentContainer: {
    paddingLeft: 10,
    paddingHorizontal: 10,
    height: MIN_CELL_HEIGHT,
    justifyContent: 'center',
  },
  buttonRowContainer: {
    flexDirection: 'row',
  },
  spacer: {
    marginBottom: 8,
  },
  button: {
    paddingHorizontal: 8,
    paddingVertical: 3, 
    borderRadius: 10,
    overflow: 'hidden',
  },
  timerButton: {
  },
  resetTimerButton: {
    backgroundColor: 'rgba(0,0,255,0.1)',
    marginLeft: 12,
  },
  buttonLabel: {
    fontWeight: '500',
  },
  label: {
    fontSize: 14,
  },
});
