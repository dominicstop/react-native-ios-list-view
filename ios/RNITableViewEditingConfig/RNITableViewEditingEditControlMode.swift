//
//  RNITableViewEditingEditControlMode.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/19/24.
//

import UIKit;
import DGSwiftUtilities;

public enum RNITableViewEditingEditControlMode: String {
  case none;
  case delete;
  case insert;
  
  var editingStyle: UITableViewCell.EditingStyle {
    switch self {
      case .none:
        return .none;
        
      case .delete:
        return .delete;
        
      case .insert:
        return .insert;
    };
  };
};

