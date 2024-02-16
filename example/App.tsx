import { StyleSheet, Text, View } from 'react-native';

import * as ReactNativeIosCollectionView from 'react-native-ios-collection-view';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ReactNativeIosCollectionView.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
