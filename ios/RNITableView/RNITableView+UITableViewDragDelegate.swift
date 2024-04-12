//
//  RNITableView+UITableViewDragDelegate.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/8/24.
//

import UIKit


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
