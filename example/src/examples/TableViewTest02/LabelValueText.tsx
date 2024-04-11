import * as React from 'react';
import { StyleSheet, View, Text, ViewStyle, TextStyle } from 'react-native';


export function LabelValueText(props: {
  style?: ViewStyle;
  labelTextStyle?: TextStyle;
  valueTextStyle?: TextStyle;
  labelText: string | number;
  valueText: string | number;
}){

  return (
    <View style={[
      styles.rootContainer,
      props.style
    ]}>
      <Text style={[
        styles.labelText,
        props.labelTextStyle,
      ]}>
        {`${props.labelText}:`}
      </Text>
      <Text style={[
        styles.valueText,
        props.valueTextStyle,
      ]}>
        {props.valueText}
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  labelText: {
    fontWeight: '500',
    opacity: 0.75,
  },
  valueText: {
    opacity: 0.5,
  },
});
