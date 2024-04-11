import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, ViewStyle } from 'react-native';

import * as Helpers from '../../functions/Helpers';
import * as Colors from '../../constants/Colors';

import { DELAY_PRESETS_MS, ListDataItem } from './Constants';
import { CellContentHeading } from './CellContentHeading';
import { LabelValueText } from './LabelValueText';


export function CellContent(props: {
  reuseIdentifier: number;
  listDataItem: ListDataItem | undefined;
  orderedListDataEntryIndex: number | undefined;
  reactListDataEntryIndex: number | undefined;
  listDataCount: number;
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


  const colorPalette = Helpers.getItemFromCyclicArray(
    Colors.COLORS_ROYGBV,
    props.listDataItem?.indexID ?? -1,
  );

  const indexID = props.listDataItem?.indexID ?? -1;
  const indexIDFormatted = `${indexID} / ${props.listDataCount -1}`;

  const buttonContainerTimerStyle: ViewStyle = {
    backgroundColor: (isIntervalActive
      ? Colors.PINK['100']
      : Colors.GREEN['100']
    ),
  };

  const buttonContainerResetCounterStyle: ViewStyle = {
    backgroundColor: ((!isIntervalActive && counter == 0)
      ? Colors.PURPLE['50']
      : Colors.BLUE['100']
    ),
  };

  return (
    <View style={styles.rootContainer}>
      <CellContentHeading
        style={styles.spacer}
        index={props.orderedListDataEntryIndex ?? 0}
        listDataItem={props.listDataItem}
        colorPalette={colorPalette}
      />
      <View style={styles.dataRowContainer}>
        <LabelValueText
          style={styles.dataColumnLeadingContainer}
          labelText={'Reuse ID'}
          valueText={props.reuseIdentifier}
        />
        <LabelValueText
          labelText={'Index ID'}
          valueText={indexIDFormatted}
        />
      </View>
      <View style={[
        styles.dataRowContainer,
        styles.spacer,
      ]}>
        <LabelValueText
          style={styles.dataColumnLeadingContainer}
          labelText={'Counter'}
          valueText={counter}
          valueTextStyle={{
            fontVariant: ['tabular-nums'],
            opacity: ((counter % 2 == 0)
              ? 0.4
              : 0.6
            ),
            fontWeight: ((counter % 2 == 0)
              ? '300'
              : '400'
            ),
          }}
        />
        <LabelValueText
          style={styles.dataColumnTrailingContainer}
          labelText={'Delay'}
          valueText={`${intervalDelayMS} ms`}
        />
      </View>
      <View style={[styles.buttonRowContainer]}>
        <TouchableOpacity 
          style={[
            styles.buttonContainer,
            styles.buttonLeadingContainer,
            buttonContainerTimerStyle,
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
          <Text>
            {isIntervalActive
              ? 'Stop Timer'
              : 'Start Timer'
            }
          </Text>
        </TouchableOpacity>
        <TouchableOpacity 
          style={[
            styles.buttonContainer,
            styles.buttonTrailingContainer,
            buttonContainerResetCounterStyle,
          ]}
          onPress={() => {
            setCounter(0);
          }}
        >
          <Text>
            {'Reset Counter'}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    paddingHorizontal: 12,
    paddingVertical: 10,
  },
  spacer: {
    marginBottom: 10,
  },
  dataRowContainer: {
    flexDirection: 'row',
  },
  dataColumnLeadingContainer: {
    marginRight: 6,
  },
  dataColumnTrailingContainer: {
    marginLeft: 6,
  },
  buttonRowContainer: {
    flexDirection: 'row',
  },
  buttonContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'red',
    borderRadius: 10,
    minHeight: 30,
  },
  buttonLeadingContainer: {
    marginRight: 6,
  },
  buttonTrailingContainer: {
    marginLeft: 6,
  },
});