//
//  RNITableViewListItemMoveOperationConfig.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/16/24.
//

import Foundation


import UIKit
import ReactNativeIosUtilities
import DGSwiftUtilities


public struct RNITableViewListItemMoveOperationConfig {
  public var sourceConfig: RNITableViewListItemTargetPositionConfig;
  public var destinationConfig: RNITableViewListItemTargetPositionConfig;
  public var shouldAnimateDifference: Bool;
};

extension RNITableViewListItemMoveOperationConfig: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    self.sourceConfig =
      try dict.getValueFromDictionary(forKey: "sourceConfig");
      
    self.destinationConfig =
      try dict.getValueFromDictionary(forKey: "destinationConfig");
      
    self.shouldAnimateDifference =
      try dict.getValueFromDictionary(forKey: "shouldAnimateDifference");
  };
};
