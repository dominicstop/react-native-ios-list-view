import * as React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { ListReorderPresetItem, ListReorderPresets } from './Constants';
import { CardButton } from '../../components/Card';
import { SpacerLine } from '../../components/Spacer';


export function ListHeader(props: {
  listDataCount: number;
  reorderPresetItem: ListReorderPresetItem;
  reorderPresetIndex: number;
  onPressNextReorderPresetButton: () => void;
}){
  return (
    <View style={styles.rootContainer}>
      <View style={styles.configContainer}>
        <Text style={styles.configTitleText}>
          {'List Re-Ordering Mode:'}
        </Text>
        <Text style={styles.configHeadingText}>
          <Text style={styles.configHeadingLabelText}>
            {'Title: '}
          </Text>
          <Text style={styles.configHeadingValueText}>
            {props.reorderPresetItem.title}
          </Text>
        </Text>
        <Text style={styles.configHeadingText}>
          <Text style={styles.configHeadingLabelText}>
            {'Desc: '}
          </Text>
          <Text style={styles.configHeadingValueText}>
            {props.reorderPresetItem.desc}
          </Text>
        </Text>
        <CardButton
          title="Next Preset Item"
          subtitle={`Current Re-order Preset: ${props.reorderPresetIndex + 1} of ${ListReorderPresets.length} items...`}
          onPress={props.onPressNextReorderPresetButton}
        />
        <SpacerLine/>
      </View>

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
    paddingTop: 6,
  },
  configContainer: {
    marginBottom: 16,
  },
  configTitleText: {
    fontSize: 24,
    fontWeight: '600',
    color: 'rgba(0,0,0,0.9)',
    textDecorationLine: 'underline',
    textDecorationColor: 'rgba(0,0,0,0.3)',
    marginBottom: 3,
  },
  configHeadingText: {
    fontSize: 16,
    marginTop: 2,
  },
  configHeadingLabelText: {
    fontWeight: '700',
    color: 'rgba(0,0,0,0.8)'
  },
  configHeadingValueText: {
    color: 'rgba(0,0,0,0.6)'
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

