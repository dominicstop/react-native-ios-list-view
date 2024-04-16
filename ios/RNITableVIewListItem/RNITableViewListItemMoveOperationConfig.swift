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

  public var moveOperationMode: RNITableViewListItemMoveOperationMode;
  public var sourceConfig: RNITableViewListItemTargetPositionConfig;
  public var shouldAnimateDifference: Bool;
  
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
    
    let sourceItemIndex = snapshot.indexOfItem(sourceItemID)!;
      
    let sourceItemSectionID =
      snapshot.sectionIdentifier(containingItem: sourceItemID)!;
    
    var destinationID: RNITableViewListItemIdentifier?;
    
    switch self.moveOperationMode {
      case let .moveToSpecificPosition(destinationConfig, _):
        destinationID = try destinationConfig.getMatchingItemIdentifier(
          inSnapshot: snapshot,
          withReactListItems: reactListItems
        );
        
      case let .moveUp(numberOfPlaces):
        let destinationItemIndex = sourceItemIndex + numberOfPlaces;
        let itemsInSection = snapshot.itemIdentifiers(inSection: sourceItemSectionID);
        
        let match = itemsInSection.enumerated().first {
          $0.offset == destinationItemIndex;
        };
        
        guard let match = match else {
          throw RNIListViewError(
            errorCode: .unexpectedNilValue,
            description: "Moving item up is out of bounds",
            extraDebugValues: [
              "numberOfPlaces": numberOfPlaces,
            ]
          );
        };
        
        destinationID = match.element;
        
      case let .moveDown(numberOfPlaces):
        let destinationItemIndex = sourceItemIndex - numberOfPlaces;
        let itemsInSection = snapshot.itemIdentifiers(inSection: sourceItemSectionID);
        
        let match = itemsInSection.enumerated().first {
          $0.offset == destinationItemIndex;
        };
        
        guard let match = match else {
          throw RNIListViewError(
            errorCode: .unexpectedNilValue,
            description: "Moving item down is out of bounds",
            extraDebugValues: [
              "numberOfPlaces": numberOfPlaces,
            ]
          );
        };
        
        destinationID = match.element;
    };
    
    guard let destinationID = destinationID else {
      throw RNIListViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get destinationID"
      );
    };
    
    let shouldMoveItemAfterDestination: Bool = {
      switch self.moveOperationMode {
        case let .moveToSpecificPosition(_, shouldMoveItemAfterDestination):
          return shouldMoveItemAfterDestination;
          
        default:
          return true;
      }
    }();
    
    if shouldMoveItemAfterDestination {
      snapshot.moveItem(sourceItemID, afterItem: destinationID);
      
    } else {
      snapshot.moveItem(sourceItemID, beforeItem: destinationID);
    };
  };
};

extension RNITableViewListItemMoveOperationConfig: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    self.moveOperationMode = try .init(fromDict: dict);
  
    self.sourceConfig =
      try dict.getValueFromDictionary(forKey: "sourceConfig");
      
    self.shouldAnimateDifference =
      try dict.getValueFromDictionary(forKey: "shouldAnimateDifference");
  };
};
