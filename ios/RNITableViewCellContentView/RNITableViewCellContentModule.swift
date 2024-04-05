//
//  RNITableViewCellContentViewModule.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/5/24.
//

import ExpoModulesCore

public class RNITableViewCellContentViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNITableViewCellContentView");

    View(RNITableViewCellContentView.self) {
      Prop("renderRequestKey"){
        $0.renderRequestKey = $1;
      };
    };
  };
};
