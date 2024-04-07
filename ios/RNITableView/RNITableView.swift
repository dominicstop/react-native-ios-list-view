import UIKit
import ExpoModulesCore
import ReactNativeIosUtilities
import DGSwiftUtilities


public class RNITableView: ExpoView {
  
  enum NativeIDKey: String {
    case renderRequest;
  };

  lazy var tableView = UITableView(frame: .zero, style: .plain);
  var dataSource: RNITableViewDataSource?;
  
  public var tableViewCellRegistry = NSMapTable<NSString, RNITableViewCell>.init(
    keyOptions: .copyIn,
    valueOptions: .weakMemory
  );

  var cellInstanceCount = 0;
  
  var renderRequestView: RNIRenderRequestView?;
  
  var _didTriggerSetup = false;
  
  var listDataOrdered: Array<RNITableViewListDataEntry> = [];
  
  // MARK: Properties - RN Props
  // ---------------------------
  
  var minimumListCellHeightProp: CGFloat = 100;
  
  var listData: Array<RNITableViewListDataEntry> = [];
  var listDataProp: Array<NSDictionary> = [] {
    willSet {
      let oldValue = self.listDataProp;
      guard newValue != oldValue else { return };
      
      let listDataNew = newValue.compactMap {
        try? RNITableViewListDataEntry(fromDict: $0 as! Dictionary<String, Any>);
      };
      
      let listDataOld = self.listData;
      guard listDataNew != listDataOld else { return };
      
      self.listData = listDataNew;
      self._notifyOnListDataPropDidUpdate(old: listDataOld, new: listDataNew);
    }
  };
  
  var listDataKeyProp: String?;
  
  // MARK: Init + Setup
  // ------------------
  
  public required init(appContext: AppContext?) {
    super.init(appContext: appContext);
    self._setupInitTableView();
  };
  
  func _setupInitTableView(){
    guard !self._didTriggerSetup else { return };
    
    let tableView = UITableView();
    tableView.dragInteractionEnabled = true;
    tableView.separatorStyle = .none;
    
    tableView.delegate = self;
    tableView.dragDelegate = self;
    tableView.dropDelegate = self;
    
    tableView.register(
      RNITableViewCell.self,
      forCellReuseIdentifier: "id"
    );
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(tableView);

    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor
      ),
      tableView.trailingAnchor.constraint(
        equalTo: self.trailingAnchor
      ),
      tableView.topAnchor.constraint(
        equalTo: self.topAnchor
      ),
      tableView.bottomAnchor.constraint(
        equalTo: self.bottomAnchor
      ),
    ]);
    
    let dataSource = self._createDataSource();
    dataSource.reactTableViewCellContainer = self;
    self.dataSource = dataSource;
    
    dataSource.defaultRowAnimation = .top;
    tableView.dataSource = dataSource;
  };
  
  // MARK: Functions - RN Lifecycle
  // ------------------------------
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    subview.removeFromSuperview();
    
    guard let nativeID = subview.nativeID,
          let nativeIDKey = NativeIDKey(rawValue: nativeID)
    else { return };
    
    switch (subview, nativeIDKey) {
      case (let renderRequestView as RNIRenderRequestView, .renderRequest):
        self.renderRequestView = renderRequestView;
        renderRequestView.renderRequestDelegate.add(self);
        
      default:
        break;
    };
  };
  
  // MARK: Functions
  // ---------------
  
  func _createDataSource() -> RNITableViewDataSource {
    return RNITableViewDataSource(
      tableView: self.tableView,
      cellProvider: { [unowned self] tableView, indexPath, key in
        
        // Create the cell as you'd usually do.
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "id",
          for: indexPath
        ) as! RNITableViewCell;
        
        self.tableViewCellRegistry.setObject(cell, forKey: key as NSString);
        
        cell.selectionStyle = .none;
        cell.reactTableViewContainer = self;
        
        cell._setupIfNeeded(renderRequestView: self.renderRequestView!);
        cell.setListDataEntry(forKey: key);
        
        self.cellInstanceCount += 1;
        return cell
      }
    );
  };
  
  func _applySnapshot(shouldAnimateRowUpdates: Bool = false) {
    guard let dataSource = self.dataSource else { return };
  
    var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
    snapshot.appendSections([0]);
    snapshot.appendItems(self.listDataOrdered.map({$0.key}));
    
    dataSource.apply(
      snapshot,
      animatingDifferences: shouldAnimateRowUpdates
    );
  };
  
  func _notifyOnListDataPropDidUpdate(
    old listDataOld: [RNITableViewListDataEntry],
    new listDataNew: [RNITableViewListDataEntry]
  ){
  
    let newItems = listDataNew.filter { item in
      let matchFromOld = listDataOld.first {
        item == $0;
      };
      
      let hasMatchFromOld = matchFromOld != nil;
      return !hasMatchFromOld;
    };
    
    let listDataOrderedFiltered =  self.listDataOrdered.filter { item in
      let matchFromNew = listDataNew.first {
        item == $0;
      };
      
      let hasMatchFromNew = matchFromNew != nil;
      return hasMatchFromNew;
    };
    
    let listDataOrderedNew = listDataOrderedFiltered + newItems;
    self.listDataOrdered = listDataOrderedNew;
    
    self._applySnapshot();
  };
  
  func _updateOrderedListData(
    usingSnapshot snapshot: NSDiffableDataSourceSnapshot<Int, String>
  ){
    
    let snapshotItems = snapshot.itemIdentifiers;
    let listDataOrderedNew = snapshotItems.map {
      RNITableViewListDataEntry(key: $0);
    };
    
    self.listDataOrdered = listDataOrderedNew;
  };
  
  func _refreshCellData(){
    let allCellsRaw =
      self.tableViewCellRegistry.objectEnumerator()?.allObjects ?? [];
      
    let allCells = allCellsRaw.compactMap {
      $0 as? RNITableViewCell;
    };
    
    allCells.forEach {
       guard let listDataEntryForCell = $0.listDataEntry else { return };
       
      let matchingListItemForCell = self.listDataOrdered.first {
        $0.key == listDataEntryForCell.key;
      };
      
       guard let matchingListItemForCell = matchingListItemForCell else { return };
       $0.setListDataEntry(forKey: matchingListItemForCell.key);
    };
  };
};

extension RNITableView: UITableViewDelegate {
};

extension RNITableView: UITableViewDragDelegate {
  public func tableView(
    _ tableView: UITableView,
    itemsForBeginning session: UIDragSession,
    at indexPath: IndexPath
  ) -> [UIDragItem] {
    guard let dataSource = self.dataSource,
          let item = dataSource.itemIdentifier(for: indexPath)
    else {
      return [];
    };
    
    let itemProvider = NSItemProvider(object: item as NSString);
    let dragItem = UIDragItem(itemProvider: itemProvider);
    dragItem.localObject = item;

    return [dragItem]
  };
};

extension RNITableView: UITableViewDropDelegate {
  public func tableView(
    _ tableView: UITableView,
    dropSessionDidUpdate session: UIDropSession,
    withDestinationIndexPath destinationIndexPath: IndexPath?
  ) -> UITableViewDropProposal {
  
    return UITableViewDropProposal(
      operation: .move,
      intent: .insertAtDestinationIndexPath
    );
  };
  
  public func tableView(
    _ tableView: UITableView,
    performDropWith coordinator: UITableViewDropCoordinator
  ) {
    // no-op
  };
};
