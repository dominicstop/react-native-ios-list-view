import { StyleSheet, View } from 'react-native';
import { CollectionView } from 'react-native-ios-list-view';


export default function App() {
  return (
    <View style={styles.container}>
      <CollectionView/>
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
