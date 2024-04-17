//
//  RNITableViewCellContentViewModule.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/5/24.
//

import ExpoModulesCore
import ReactNativeIosUtilities
import DGSwiftUtilities

public class RNITableHeaderViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNITableHeaderView");
    
    View(RNITableHeaderView.self) {
    };
  };
};
