//
//  RNITableViewDataSource.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import ExpoModulesCore
import UIKit
import ReactNativeIosUtilities


public typealias RNITableViewDataSourceSnapshot = NSDiffableDataSourceSnapshot<
  RNITableViewListSectionIdentifier,
  RNITableViewListItemIdentifier
>;

public class RNITableViewDataSource: UITableViewDiffableDataSource<
  RNITableViewListSectionIdentifier,
  RNITableViewListItemIdentifier
> {

  public weak var reactTableViewCellContainer: RNITableView?;
  
  // MARK: - UITableViewDiffableDataSource
  // -------------------------------------

  public override func tableView(
    _ tableView: UITableView,
    canMoveRowAt indexPath: IndexPath
  ) -> Bool {
    return true;
  };
  
  public override func tableView(
    _ tableView: UITableView,
    moveRowAt sourceIndexPath: IndexPath,
    to destinationIndexPath: IndexPath
  ) {
    guard sourceIndexPath != destinationIndexPath,
    
          let sourceItemID = itemIdentifier(for: sourceIndexPath),
          let destinationItemID = itemIdentifier(for: destinationIndexPath)
    else { return };
    
    var snapshot = self.snapshot();
    
    if destinationIndexPath.row > sourceIndexPath.row {
      snapshot.moveItem(sourceItemID, afterItem: destinationItemID);
      
    } else {
      snapshot.moveItem(sourceItemID, beforeItem: destinationItemID);
    };
    
    self.apply(snapshot, animatingDifferences: false);
    
    guard let reactTableViewCellContainer = self.reactTableViewCellContainer
    else { return };
    
    reactTableViewCellContainer._updateOrderedListData(usingSnapshot: snapshot);
    reactTableViewCellContainer._refreshCellData();
  };
  
  // MARK: - Functions
  // -----------------
    
  public func sectionIdentifier(
    forSectionIndex sectionIndex: Int,
    usingSnapshot snapshot: RNITableViewDataSourceSnapshot? = nil
  ) -> RNITableViewListSectionIdentifier? {
    
    let snapshot = snapshot ?? self.snapshot();
    
    if snapshot.numberOfSections == 1,
       sectionIndex == 0 {
      
      return snapshot.sectionIdentifiers.first;
    };
    
    return snapshot.sectionIdentifiers.first {
      let indexForSectionIdentifier = snapshot.indexOfSection($0);
      return indexForSectionIdentifier == sectionIndex;
    };
  };
};

