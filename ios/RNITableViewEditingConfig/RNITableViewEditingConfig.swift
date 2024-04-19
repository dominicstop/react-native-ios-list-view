//
//  RNITableViewEditingConfig.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/19/24.
//

import Foundation
import DGSwiftUtilities


public struct RNITableViewEditingConfig: Equatable {
  public static var `default`: Self = .init(
    isEditing: false,
    defaultReorderControlMode: .visible,
    defaultEditControlMode: .none
  );

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
