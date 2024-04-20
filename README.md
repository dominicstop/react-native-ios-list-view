# react-native-ios-list-view

An experimental component for using `UITableView` (and eventually `UIColletionView`) in `react-native`.

<br><br>

| Gif                                                    | Description                                                  |
| ------------------------------------------------------ | ------------------------------------------------------------ |
| ![TableViewTest02-01](./assets/TableViewTest02-01.gif) | **Component**: [TableViewTest02Screen](example/src/examples/TableViewTest02Screen/TableViewTest02Screen.tsx)<br><br>**Desc**:<br>1️⃣. This gif shows a `UITableView` using react components for the cell content.<br><br>2️⃣. Shows using an "array of JS objects" prop as the `UITableViewDataSource` for the table view.<br><br>3️⃣  Shows re-ordering the `UITableView` rows via the the iOS 11+  [drag & drop API](https://developer.apple.com/documentation/uikit/drag_and_drop) (i.e. `UITableViewDragDelegate`, `UITableViewDropDelegate`).<br><br>4️⃣. Shows a `UITableView` with self-sizing cells.<br><br>5️⃣. Shows `UITableView`'s cell re-use logic reusing the react components.<br><br> |
| ![TableViewTest03-01](./assets/TableViewTest03-01.gif) | **Component**: [TableViewTest03Screen](example/src/examples/TableViewTest03Screen/TableViewTest03Screen.tsx)<br/><br/>**Desc**: This gif shows programmatically moving the `UITableView` rows up and down via calling a module command. |

