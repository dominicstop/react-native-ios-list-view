//
//  RNITableViewEditingConfig.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/19/24.
//

import Foundation
import DGSwiftUtilities


public struct RNITableViewEditingConfig {
  public var isEditing: Bool;
  public var defaultReorderControlMode: RNITableViewEditingReorderControlMode;
  public var defaultEditControlMode: RNITableViewEditingEditControlMode;
};

extension RNITableViewEditingConfig: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    self.isEditing =
      try dict.getValueFromDictionary(forKey: "isEditing");
    
    self.defaultReorderControlMode =
      try dict.getEnumFromDictionary(forKey: "defaultReorderControlMode");
      
    self.defaultEditControlMode =
      try dict.getEnumFromDictionary(forKey: "defaultEditControlMode");
  };
};
