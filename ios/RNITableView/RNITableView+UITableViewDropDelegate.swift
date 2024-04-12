//
//  RNITableView+UITableViewDropDelegate.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/8/24.
//

import UIKit


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
  
  public func tableView(
    _ tableView: UITableView,
    dropSessionDidEnd session: UIDropSession
  ) {
    self.dragState = .dropped;
  };
};
