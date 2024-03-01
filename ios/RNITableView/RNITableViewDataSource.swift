//
//  RNITableViewDataSource.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import ExpoModulesCore
import UIKit
import ReactNativeIosUtilities


class RNITableViewDataSource: UITableViewDiffableDataSource<Int, String> {
  
  override func tableView(
    _ tableView: UITableView,
    canMoveRowAt indexPath: IndexPath
  ) -> Bool {
    return true;
  };
  
  override func tableView(
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
        
    apply(snapshot, animatingDifferences: false);
  };
};

