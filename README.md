# react-native-ios-list-view

An experimental component for using `UITableView` (and eventually `UIColletionView`) in `react-native`.

<br><br>

## Demo/Test Gifs + Description

| Gif                                                          | Description                                                  |
| :----------------------------------------------------------- | ------------------------------------------------------------ |
| ![TableViewTest02-01](./assets/TableViewTest02-01.gif)<br><br>![TableViewTest02-02](./assets/TableViewTest02-02.gif) | **Component**: [TableViewTest02Screen](example/src/examples/TableViewTest02Screen/TableViewTest02Screen.tsx)<br><br>**Desc**:<br>1️⃣. This gif shows a `UITableView` using react components for the cell content.<br><br>2️⃣. Shows using an "array of JS objects" prop as the `UITableViewDataSource` for the table view.<br><br>3️⃣  Shows re-ordering the `UITableView` rows via the the iOS 11+  [drag & drop API](https://developer.apple.com/documentation/uikit/drag_and_drop) (i.e. `UITableViewDragDelegate`, `UITableViewDropDelegate`).<br><br>4️⃣. Shows a `UITableView` with self-sizing cells.<br><br>5️⃣. Shows `UITableView`'s cell re-use logic reusing the react components (i.e. the timer and counter state is preserved across rows, but the cell content changes).<br><br> |
| ![TableViewTest03-01](./assets/TableViewTest03-01.gif)       | **Component**: [TableViewTest03Screen](example/src/examples/TableViewTest03Screen/TableViewTest03Screen.tsx)<br><br>**Desc**: This gif shows programmatically moving the `UITableView` rows up and down via calling a module command. |
| ![TableViewTest03-02](./assets/TableViewTest03-02.gif) <br><br>![TableViewTest03-03](./assets/TableViewTest03-03.gif) | **Component**: [TableViewTest03Screen](example/src/examples/TableViewTest03Screen/TableViewTest03Screen.tsx)<br><br>**Desc**:<br>1️⃣. This gif shows changing which API to use to re-order the rows (i.e. drag and drop interaction, and `UItableView.isEditing` mode).<br><br>2️⃣. Shows table row reordering via `UITableView.isEditing` mode + using the standard re-ordering control to drag and move the rows.<br><br>3️⃣. Shows table row reordering via `UITableView.isEditing` mode + using a custom react component for the re-ordering control (e.g. the color hex title container).<br><br>4️⃣. Shows table row reordering via the iOS 11+ drag and drop API (i.e. `UITableViewDragDelegate`, and `UITableViewDropDelegate`).<br><br><br>📝 **Note**: Reordering via `UITableView.isEditing` locks the row's x-axis (i.e. you can only move it up or down), while row re-ordering via the drag and drop API allows you to move it freely.<br><br> |
| ![TableViewTest02-03](./assets/TableViewTest02-03.gif)<br><br>![TableViewTest03-04](./assets/TableViewTest03-04.gif) | **Component**: [TableViewTest02Screen](example/src/examples/TableViewTest02Screen/TableViewTest02Screen.tsx)<br/><br/>**Desc**: This gifs shows the `TableView.shouldSetCellLoadingOnScrollToTop` prop being set to true, and invoking scrolls to top when the status bar is pressed.<br/><br/>📝 **Note**: Since this gif has been made, some improvements to the cell re-use logic has been made, so the amount of time the "loading indicator" is shown has been reduced. |

<br><br>

## 🚧⚠️ Re-Write WIP 🚧⚠️

This library is being re-written to support the new architecture. Please see this is [issue](https://github.com/dominicstop/react-native-ios-context-menu/issues/100#issuecomment-2077986438) for progress 😔
