import * as React from 'react';
import { StyleSheet, View, Text, ViewStyle, TextStyle } from 'react-native';

import * as Helpers from '../../functions/Helpers';
import * as Colors from '../../constants/Colors';

import { ListDataItem } from './Constants';


export function CellContentHeading(props: {
  style?: ViewStyle;
  index: number;
  listDataItem: ListDataItem | undefined;
  colorPalette: typeof Colors.COLORS_ROYGBV[number]
}){

  const headingIndexPrefixText = (() => {
    const index = `${props.index + 1}`;

    if(index.length == 1){
      return `00`;
    };

    if(index.length == 2){
      return `0`;
    };

    return "";
  })();

  const headingTitleText = Helpers.capitalizeString(
    props.listDataItem?.title ?? "N/A"
  );

  const headingIndexContainerStyle: ViewStyle = {
    backgroundColor: props.colorPalette['100'],
  };

  const headingTitleTextStyle: TextStyle = {
  };

  return (
    <View style={[
      styles.rootContainer,
      props.style
    ]}>
      <View style={styles.headingTitleContainer}>
        <View style={[
          styles.headingIndexContainer,
          headingIndexContainerStyle,
        ]}>
          <Text style={styles.headingIndexText}>
            <Text style={styles.headingIndexPrefixText}>
              {headingIndexPrefixText}
            </Text>
            {`${props.index + 1}`}
          </Text>
        </View>
        <Text style={[
          styles.headingTitleText,
          headingTitleTextStyle,
        ]}>
          {headingTitleText}
        </Text>
      </View>
      <Text style={styles.descriptionText}>
        <Text style={styles.descriptionIndicatorLabelText}>
          {'Description: '}
        </Text>
        {props.listDataItem?.desc ?? "N/A"}
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
  },
  headingTitleContainer: {
    flexDirection:'row',
    marginBottom: 7,
  },
  headingIndexContainer: {
    overflow: 'hidden',
    minWidth: 55,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
  },
  headingIndexText: {
    fontFamily: 'Baskerville-BoldItalic',
    fontSize: 16,
    opacity: 0.7,
    fontVariant: ['tabular-nums'],
    fontStyle: 'italic',
    letterSpacing: 1.75,
  },
  headingIndexPrefixText: {
    opacity: 0.6,
  },
  headingTitleText: {
    fontFamily: 'Baskerville-SemiBold',
    fontSize: 22,
    fontWeight: '600',
    marginLeft: 5,
    opacity: 0.75,
    textDecorationLine: 'underline',
    textDecorationColor: 'rgba(0,0,0,0.4)'
  },
  descriptionText: {
    fontSize: 14,
    color: 'rgba(0,0,0,0.45)',
  },
  descriptionIndicatorLabelText: {
    fontWeight: '500',
    fontSize: 14.5,
    color: 'rgba(0,0,0,0.8)',
  },
});
