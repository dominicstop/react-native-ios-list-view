//
//  RNIRenderRequestViewModule.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import Foundation
import ExpoModulesCore

public class RNIRenderRequestViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNIRenderRequestView");

    View(RNIRenderRequestView.self) {
       Events("onRenderRequest");
    };
  };
};
