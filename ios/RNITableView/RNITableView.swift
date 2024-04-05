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
  
  var cellInstanceCount = 0;
  
  var renderRequestView: RNIRenderRequestView?;
  
  var _didTriggerSetup = false;
  
  var listDataOrdered: Array<RNITableViewListDataEntry> = [];
  
  // MARK: Properties - RN Props
  // ---------------------------
  
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
    self.dataSource = dataSource;
    
    dataSource.defaultRowAnimation = .top;
    tableView.dataSource = dataSource;
  };
  
  // MARK: Functions - RN Lifecycle
  // ------------------------------
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    
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
        let listItem = self.listDataOrdered.first {
          $0.key == key;
        };
        
        // Create the cell as you'd usually do.
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "id",
          for: indexPath
        ) as! RNITableViewCell;
        
        cell.selectionStyle = .none;
        cell.setupIfNeeded(renderRequestView: self.renderRequestView!);
        
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
    
    self.listDataOrdered = listDataOrderedFiltered + newItems;
    self._applySnapshot();
  };
};

extension RNITableView: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 65;
  };
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
