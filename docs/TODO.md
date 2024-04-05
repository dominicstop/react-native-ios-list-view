# TODO - `react-native-ios-list-view`

<br>

- [ ] **Impl**: `RNITableViewCellContent` - Create custom view for `RNITableView`'s cell content.
- [ ] **Impl**: `TableView.renderCellContent` + `TableView.listData` - Pass the corresponding `listData` item for the current cell.
- [ ] **Impl**: `TableView.initialCellsToRenderCount` Logic
  * Related: Cell render request logic.
  * Problem: We don't know how many cells to render beforehand; this causes the cells to render sequentially on screen.
  * Solution: Initial pool of cells via ahead of time rendering for cells (i.e. mount + render a bunch of cells in advanced), then throw away any excess cells after the table view has completed rendering the initial cells to show.<br><br>
- [ ] **Fix**: `RNITableView` Cell Layout

<br><br>

## Completed Tasks

- [x] **Impl**: `RNIRenderRequestableView` Protocol - Create protocol for `RNIRenderRequestView` view items.
- [x] **Impl**: `TableView.renderCellContent` Prop - Use custom render content from the table view cell.
- [x] **Impl**: `TableView.listData` Prop - Allow for use of custom data for the table view.