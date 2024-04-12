//
//  RNITableViewDataSource.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import ExpoModulesCore
import UIKit
import ReactNativeIosUtilities


public class RNITableViewDataSource: UITableViewDiffableDataSource<Int, String> {

  public weak var reactTableViewCellContainer: RNITableView?;

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
      snapshot.appendItems([fromItem], toSection: sourceIndexPath.section)
    };
    
    self.apply(snapshot, animatingDifferences: false);
    
    guard let reactTableViewCellContainer = self.reactTableViewCellContainer
    else { return };
    
    reactTableViewCellContainer._updateOrderedListData(usingSnapshot: snapshot);
    reactTableViewCellContainer._refreshCellData();
    
  };
};

