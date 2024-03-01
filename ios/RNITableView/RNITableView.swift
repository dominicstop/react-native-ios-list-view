import ExpoModulesCore
import UIKit
import ReactNativeIosUtilities

struct ListData: Hashable {
  var key: String;
};

public class RNITableView: ExpoView, RNIRenderRequestDelegate {
  
  enum NativeIDKey: String {
    case renderRequest;
  };

  lazy var tableView = UITableView(frame: .zero, style: .plain);
  var dataSource: UITableViewDiffableDataSource<Int, String>?;
  
  var cellInstanceCount = 0;
  
  var renderRequestView: RNIRenderRequestView?;
  
  var _didTriggerSetup = false;
  
  var listData: [ListData] = {
    (0...15).map {
      ListData(key: "\($0)");
    };
  }();
  
  public required init(appContext: AppContext?) {
    super.init(appContext: appContext);
    self._setupInitTableView();
  };
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    
    guard let nativeID = subview.nativeID,
          let nativeIDKey = NativeIDKey(rawValue: nativeID)
    else { return };
    
    switch (subview, nativeIDKey) {
      case (let renderRequestView as RNIRenderRequestView, .renderRequest):
        self.renderRequestView = renderRequestView;
        renderRequestView.renderRequestDelegate.add(self);
        self._applySnapshot();
        
      default:
        break;
    };
  };
  
  func _setupInitTableView(){
    guard !self._didTriggerSetup else { return };
    let tableView = UITableView();
    
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
  
  func _createDataSource() -> UITableViewDiffableDataSource<Int, String> {
    return UITableViewDiffableDataSource(
      tableView: self.tableView,
      cellProvider: { [unowned self] tableView, indexPath, key in
        let listItem = self.listData.first(where: { $0.key == key })!;
        
        // Create the cell as you'd usually do.
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "id",
          for: indexPath
        ) as! RNITableViewCell;
        
        self.cellInstanceCount += 1;
        
        cell.setupIfNeeded(renderRequestView: self.renderRequestView!);
        return cell
      }
    );
  };
  
  func _applySnapshot(shouldAnimateRowUpdates: Bool = false) {
    guard let dataSource = self.dataSource else { return };
  
    var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
    snapshot.appendSections([0]);
    snapshot.appendItems(self.listData.map({$0.key}));
    
    dataSource.apply(
      snapshot,
      animatingDifferences: shouldAnimateRowUpdates
    );
  };
  
  func onRenderRequestCompleted(renderRequestKey: Int, view: UIView) {
    let renderRequestView = self.renderRequestView!;
    
    let didRegisterAllCells =
      renderRequestView.renderRequestRegistry.count == self.cellInstanceCount;
      
    guard didRegisterAllCells else { return };
      
 
  };
};
