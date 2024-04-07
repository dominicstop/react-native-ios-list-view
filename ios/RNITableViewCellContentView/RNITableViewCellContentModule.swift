//
//  RNITableViewCellContentViewModule.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/5/24.
//

import ExpoModulesCore
import ReactNativeIosUtilities
import DGSwiftUtilities

public class RNITableViewCellContentViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNITableViewCellContentView");
    
    AsyncFunction("notifyOnReactLayout") {
      (reactTag: Int, args: Dictionary<String, Any>, promise: Promise) in
    
      DispatchQueue.main.async {
        do {
          let detachedView = try RNIModuleHelpers.getView(
            withErrorType: RNIListViewError.self,
            forNode: reactTag,
            type: RNITableViewCellContentView.self
          );
        
          let layoutRect = try CGRect(fromDict: args);
          detachedView.notifyOnReactLayout(forRect: layoutRect);
          
          promise.resolve();
        
        } catch let error {
          promise.reject(error);
          return;
        };
      };
    };

    View(RNITableViewCellContentView.self) {
      Events("onDidSetListDataEntry");
      
      Prop("renderRequestKey"){
        $0.renderRequestKeyProp = $1;
      };
    };
  };
};
