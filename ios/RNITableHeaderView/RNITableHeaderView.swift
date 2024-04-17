//
//  RNITableHeaderView.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/18/24.
//

import UIKit
import ExpoModulesCore
import ReactNativeIosUtilities
import DGSwiftUtilities


public class RNITableHeaderView: ExpoView {

  // MARK: Properties
  // ----------------
  
  public var reactTableViewWrapper: RNITableView?;
  
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    
    print(
      "RNITableHeaderView.layoutSubviews",
      "- frame.origin", self.frame.origin,
      "- frame.size", self.frame.size
    );
  };
};
