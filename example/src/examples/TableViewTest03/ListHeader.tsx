import * as React from 'react';
import { View, Text, StyleSheet } from 'react-native';


export function ListHeader(props: {
  listDataCount: number;
}){
  return (
    <View style={styles.rootContainer}>
      <Text style={styles.headingText}>
        <Text style={styles.headingCountText}>
          {`${props.listDataCount}`}
        </Text>
        {` items`}
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    paddingHorizontal: 12,
    paddingBottom: 8,
    paddingTop: 4,
  },
  headingText: {
    fontSize: 40,
    fontWeight: '300',
    color: 'rgba(0,0,0,0.5)',
  },
  headingCountText: {
    fontWeight: '700',
    color: 'rgba(0,0,0,0.8)',
    fontVariant: ['tabular-nums'],
    letterSpacing: 1.2,
  },
});

