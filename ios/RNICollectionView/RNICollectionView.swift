import ExpoModulesCore


public class RNICollectionView: ExpoView {
  
  public required init(appContext: AppContext?) {
    super.init(appContext: appContext);
  };
  
  func _setup(){
    let collectionView = UICollectionView();
    
    collectionView.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: "RNICollectionViewCell"
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

extension RNICollectionView: UICollectionViewDataSource {

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
  
    return 3;
  };
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
  
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "RNICollectionViewCell",
      for: indexPath
    );
    
    let color: UIColor = indexPath.item % 2 == 0 ? .red : .blue;
    cell.backgroundColor = color;
    
    return cell;
  };
};

extension RNICollectionView: UICollectionViewDelegate {
  
};
