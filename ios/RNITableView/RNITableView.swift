import UIKit
import ExpoModulesCore
import ReactNativeIosUtilities
import DGSwiftUtilities


public class RNITableView: ExpoView {
  
  public enum NativeIDKey: String {
    case renderRequest;
    case listHeader;
    case customReorderControl;
  };
  
  // MARK: - Properties
  // ------------------
  
  public var tableView: UITableView?;
  public var dataSource: RNITableViewDataSource?;
  
  public var listDataOrdered: Array<RNITableViewListItem> = [];
  
  public lazy var cellManager =
    RNITableViewCellManager(reactTableViewWrapper: self);

  public var renderRequestView: RNIRenderRequestView?;
  
  public var dragState: RNITableViewDragState = .idle {
    willSet {
      print("RNITableView.dragState - willSet - newValue: \(newValue)");
    }
  };
  
  var _didTriggerSetup = false;
  
  // MARK: Properties - RN Props
  // ---------------------------
  
  public var minimumListCellHeightProp: CGFloat = 100;
  
  public var listData: Array<RNITableViewListItem> = [];
  public var listDataProp: Array<NSDictionary> = [] {
    willSet {
      let oldValue = self.listDataProp;
      guard newValue != oldValue else { return };
      
      let listDataNew = newValue.compactMap {
        try? RNITableViewListItem(fromDict: $0 as! Dictionary<String, Any>);
      };
      
      let listDataOld = self.listData;
      guard listDataNew != listDataOld else { return };
      
      self.listData = listDataNew;
      self._notifyOnListDataPropDidUpdate(old: listDataOld, new: listDataNew);
    }
  };
  
  public var isEditingConfig: RNITableViewEditingConfig = .default;
  public var isEditingConfigProps: Dictionary<String, Any>? {
    willSet {
      let isEditingConfig: RNITableViewEditingConfig = {
        guard let newValue = newValue else {
          return .default;
        };
        
        return (try? .init(fromDict: newValue)) ?? .default;
      }();
      
      self.isEditingConfig = isEditingConfig;
      
      if let tableView = self.tableView,
         tableView.isEditing != isEditingConfig.isEditing {
         
        DispatchQueue.main.async {
          tableView.setEditing(isEditingConfig.isEditing, animated: false);
        };
      };
    }
  };
  
  public var dragInteractionEnabledProp: Bool = false {
    willSet {
      let oldValue = self.dragInteractionEnabledProp;
      guard newValue != oldValue,
            self.tableView?.dragInteractionEnabled != newValue
      else { return };
      
      self.tableView?.dragInteractionEnabled = newValue;
    }
  };
  
  // MARK: Init + Setup
  // ------------------
  
  public required init(appContext: AppContext?) {
    super.init(appContext: appContext);
    self._setupInitTableView();
  };
  
  func _setupInitTableView(){
    guard !self._didTriggerSetup else { return };
    
    let tableView = UITableView();
    self.tableView = tableView;
    
    tableView.dragInteractionEnabled = self.dragInteractionEnabledProp;
    tableView.isEditing = self.isEditingConfig.isEditing;
    
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
    
    let dataSource = self._setupCreateDataSource();
    dataSource.reactTableViewCellContainer = self;
    self.dataSource = dataSource;
    
    dataSource.defaultRowAnimation = .top;
    tableView.dataSource = dataSource;
  };
  
  func _setupCreateDataSource() -> RNITableViewDataSource {
    return RNITableViewDataSource(
      tableView: self.tableView!,
      cellProvider: { [unowned self] tableView, indexPath, key in
        
        // Create the cell as you'd usually do.
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "id",
          for: indexPath
        ) as! RNITableViewCell;
        
        cell.selectionStyle = .none;
        cell.reactTableViewContainer = self;
        
        cell.showsReorderControl = false;
        
        cell._setupIfNeeded(renderRequestView: self.renderRequestView!);
        cell._notifyWillDisplay(forKey: key, indexPath: indexPath);
        
        return cell
      }
    );
  };

  // MARK: Functions - RN Lifecycle
  // ------------------------------
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    guard let nativeID = subview.nativeID,
          let nativeIDKey = NativeIDKey(rawValue: nativeID)
    else { return };
    
    switch (subview, nativeIDKey) {
      case (let renderRequestView as RNIRenderRequestView, .renderRequest):
        self.renderRequestView = renderRequestView;
        renderRequestView.renderRequestDelegate.add(self);
        
      case (let listHeaderView as RNITableHeaderView, .listHeader):
        guard let tableView = self.tableView else { return  };
        
        listHeaderView.reactTableViewWrapper = self;
        tableView.tableHeaderView = listHeaderView;
        
      default:
        break;
    };
  };

  // MARK: Module Functions
  // ----------------------
  
  public func requestToMoveListItem(usingDict dict: Dictionary<String, Any>) throws {
    guard let dataSource = self.dataSource else {
      throw RNIListViewError(
        errorCode: .unexpectedNilValue,
        description: "dataSource is nil"
      );
    };
    
    let config = try RNITableViewListItemMoveOperationConfig(fromDict: dict);
    var snapshot = dataSource.snapshot();
    
    try config.applyConfig(
      toSnapshot: &snapshot,
      withReactListItems: self.listData
    );
    
    dataSource.apply(
      snapshot,
      animatingDifferences: config.shouldAnimateDifference
    );
  };

  // MARK: Functions
  // ---------------
  
  func _applySnapshot(shouldAnimateRowUpdates: Bool = false) {
    guard let dataSource = self.dataSource else { return };
  
    // WIP
    var snapshot = RNITableViewDataSourceSnapshot();
    snapshot.appendSections(["0"]);
    snapshot.appendItems(self.listDataOrdered.map({$0.key}));
    
    dataSource.apply(
      snapshot,
      animatingDifferences: shouldAnimateRowUpdates
    );
  };
  
  func _notifyOnListDataPropDidUpdate(
    old listDataOld: [RNITableViewListItem],
    new listDataNew: [RNITableViewListItem]
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
    usingSnapshot snapshot: RNITableViewDataSourceSnapshot
  ){
    
    // WIP - does not take sections into account
    let snapshotItems = snapshot.itemIdentifiers;
    let listDataOrderedNew = snapshotItems.map {
      RNITableViewListItem(key: $0);
    };
    
    self.listDataOrdered = listDataOrderedNew;
  };
  
  func _refreshCellData(){
    let allCells = self.cellManager.cellInstances;
    
    allCells.forEach {
       guard let listItemForCell = $0.listItem else { return };
       
      let matchingListItemForCell = self.listDataOrdered.first {
        $0.key == listItemForCell.key;
      };
      
       guard let matchingListItemForCell = matchingListItemForCell else { return };
       $0.setListItem(forKey: matchingListItemForCell.key);
    };
  };
};
