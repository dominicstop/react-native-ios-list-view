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
  public var shouldMoveItemAfterDestination: Bool;
  
  public func applyConfig(
    toSnapshot snapshot: inout RNITableViewDataSourceSnapshot,
    withReactListItems reactListItems: [RNITableViewListItem]
  ) throws {
    
    let sourceItemID = try? self.sourceConfig.getMatchingItemIdentifier(
      inSnapshot: snapshot,
      withReactListItems: reactListItems
    );
    
    guard let sourceItemID = sourceItemID else {
      throw RNIListViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get sourceItemID"
      );
    };
    
    let destinationID = try? sourceConfig.getMatchingItemIdentifier(
      inSnapshot: snapshot,
      withReactListItems: reactListItems
    );
    
    guard let destinationID = destinationID else {
      throw RNIListViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get destinationID"
      );
    };
    
    if self.shouldMoveItemAfterDestination {
      snapshot.moveItem(sourceItemID, afterItem: destinationID);
      
    } else {
      snapshot.moveItem(sourceItemID, afterItem: destinationID);
    };
  };
};

extension RNITableViewListItemMoveOperationConfig: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    self.sourceConfig =
      try dict.getValueFromDictionary(forKey: "sourceConfig");
      
    self.destinationConfig =
      try dict.getValueFromDictionary(forKey: "destinationConfig");
      
    self.shouldAnimateDifference =
      try dict.getValueFromDictionary(forKey: "shouldAnimateDifference");
      
    self.shouldMoveItemAfterDestination =
      try dict.getValueFromDictionary(forKey: "shouldMoveItemAfterDestination");
  };
};
