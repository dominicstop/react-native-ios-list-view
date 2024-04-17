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
    
    AsyncFunction("notifyOnReactLayout") {
      (reactTag: Int, args: Dictionary<String, Any>, promise: Promise) in
    
      DispatchQueue.main.async {
        do {
          let view = try RNIModuleHelpers.getView(
            withErrorType: RNIListViewError.self,
            forNode: reactTag,
            type: RNITableHeaderView.self
          );
          
          let layoutRectDict = try args.getValueFromDictionary(
            forKey: "layoutRect",
            type: Dictionary<String, Any>.self
          );
          
          let layoutRect = try CGRect(fromDict: layoutRectDict);
          
          // view.notifyOnReactLayout(
          //   forRect: layoutRect,
          //   renderRequestKey: renderRequestKey
          // );
          
          promise.resolve();
        
        } catch let error {
          promise.reject(error);
          return;
        };
      };
    };

    View(RNITableHeaderView.self) {
    };
  };
};
