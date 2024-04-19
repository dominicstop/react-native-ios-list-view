//
//  RNITableView+UITableViewDelegate.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/8/24.
//

import UIKit


extension RNITableView: UITableViewDelegate {

  public func tableView(
    _ tableView: UITableView,
    shouldIndentWhileEditingRowAt indexPath: IndexPath
  ) -> Bool {
  
    return false;
  };
  
  public func tableView(
    _ tableView: UITableView,
    editingStyleForRowAt indexPath: IndexPath
  ) -> UITableViewCell.EditingStyle {
    
    return self.isEditingConfig.defaultEditControlMode.editingStyle;
  };
};
