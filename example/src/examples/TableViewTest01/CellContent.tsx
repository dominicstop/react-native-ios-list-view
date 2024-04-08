import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, ViewStyle } from 'react-native';

import * as Helpers from '../../functions/Helpers';
import { DELAY_PRESETS_MS, ListDataItem, MIN_CELL_HEIGHT } from './Constants';


export function CellContent(props: {
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
    <View style={styles.rootContainer}>
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

const styles = StyleSheet.create({
  rootContainer: {
    paddingHorizontal: 10,
    minHeight: MIN_CELL_HEIGHT,
    justifyContent: 'center',
    paddingVertical: 5,
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