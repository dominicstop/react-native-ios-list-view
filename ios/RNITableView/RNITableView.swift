import ExpoModulesCore


public class RNITableView: ExpoView {
  
  public required init(appContext: AppContext?) {
    super.init(appContext: appContext);
  };
  
  func _setup(){
    let collectionView = UITableView();
    
    collectionView.register(
      UITableViewCell.self,
      forCellWithReuseIdentifier: "RNITableViewCell"
    );
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    self.addSubview(collectionView);
    collectionView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor .constraint(equalTo: self.leadingAnchor ),
      collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      collectionView.topAnchor     .constraint(equalTo: self.topAnchor     ),
      collectionView.bottomAnchor  .constraint(equalTo: self.bottomAnchor  ),
    ]);
  };
};

extension RNITableView: UITableViewDataSource {

  public func collectionView(
    _ collectionView: UITableView,
    numberOfItemsInSection section: Int
  ) -> Int {
  
    return 3;
  };
  
  public func collectionView(
    _ collectionView: UITableView,
    cellForItemAt indexPath: IndexPath
  ) -> UITableViewCell {
  
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "RNITableViewCell",
      for: indexPath
    );
    
    let color: UIColor = indexPath.item % 2 == 0 ? .red : .blue;
    cell.backgroundColor = color;
    
    return cell;
  };
};

extension RNITableView: UITableViewDelegate {
  
};
