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
    guard let fromItem = itemIdentifier(for: sourceIndexPath),
          sourceIndexPath != destinationIndexPath
    else { return }
        
    var snapshot = self.snapshot();
    snapshot.deleteItems([fromItem]);
        
    if let toItem = itemIdentifier(for: destinationIndexPath) {
       let isAfter = destinationIndexPath.row > sourceIndexPath.row;
            
      if isAfter {
        snapshot.insertItems([fromItem], afterItem: toItem);
          
      } else {
        snapshot.insertItems([fromItem], beforeItem: toItem);
      };
      
    } else {
      let targetSectionID = self.sectionIdentifier(
        forSectionIndex: sourceIndexPath.section,
        usingSnapshot: snapshot
      );
      
      snapshot.appendItems([fromItem], toSection: targetSectionID);
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

