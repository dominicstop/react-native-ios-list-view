import { StyleSheet, View } from 'react-native';
import { TableView } from 'react-native-ios-list-view';


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

export default function App() {
  return (
    <View style={styles.container}>
      <TableView
        style={styles.tableView}
        listData={LIST_DATA}
        listDataKeyExtractor={(
          item: Record<string, typeof LIST_DATA[number]>, 
          index: number
        ) => {
          return `${item.indexID}`;
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
});
