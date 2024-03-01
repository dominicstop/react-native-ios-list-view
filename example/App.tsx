import { StyleSheet, View } from 'react-native';
import { TableView } from 'react-native-ios-list-view';


export default function App() {
  return (
    <View style={styles.container}>
      <TableView
        style={styles.tableView}
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
});
