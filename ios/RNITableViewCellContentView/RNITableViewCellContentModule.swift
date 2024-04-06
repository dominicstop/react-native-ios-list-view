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
      Events("onDidSetListDataEntry");
      
      Prop("renderRequestKey"){
        $0.renderRequestKeyProp = $1;
      };
    };
  };
};
