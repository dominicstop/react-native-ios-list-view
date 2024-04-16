//
//  RNITableViewListItemMoveOperationMode.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/16/24.
//

import UIKit
import ReactNativeIosUtilities
import DGSwiftUtilities


public enum RNITableViewListItemMoveOperationMode {
  case moveToSpecificPosition(
    destinationConfig: RNITableViewListItemTargetPositionConfig,
    shouldMoveItemAfterDestination: Bool
  );
  
  case moveUp(numberOfPlaces: Int);
  case moveDown(numberOfPlaces: Int);
};

extension RNITableViewListItemMoveOperationMode: EnumCaseStringRepresentable {

  public var caseString: String {
    switch self {
      case .moveToSpecificPosition:
        return "moveToSpecificPosition";
        
      case .moveUp:
        return "moveUp";
        
      case .moveDown:
        return "moveDown";
    };
  };
};

extension RNITableViewListItemMoveOperationMode: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    guard let modeString: String = try dict.getValueFromDictionary(forKey: "mode") else {
      throw RNIListViewError(
        errorCode: .guardCheckFailed,
        description: "Unable to parse value for mode in dict",
        extraDebugValues: [
          "dict": dict,
        ]
      );
    };
    
    switch modeString {
      case "moveToSpecificPosition":
        let destinationConfig = try dict.getValueFromDictionary(
          forKey: "destinationConfig",
          type: RNITableViewListItemTargetPositionConfig.self
        );
        
        let shouldMoveItemAfterDestination = try dict.getValueFromDictionary(
          forKey: "shouldMoveItemAfterDestination",
          type: Bool.self
        );
        
        self = .moveToSpecificPosition(
          destinationConfig: destinationConfig,
          shouldMoveItemAfterDestination: shouldMoveItemAfterDestination
        );
        
      case "moveUp":
        let numberOfPlaces = try dict.getValueFromDictionary(
          forKey: "numberOfPlaces",
          type: Int.self
        );
        
        self = .moveUp(numberOfPlaces: numberOfPlaces);
        
      case "moveDown":
        let numberOfPlaces = try dict.getValueFromDictionary(
          forKey: "numberOfPlaces",
          type: Int.self
        );
        
        self = .moveDown(numberOfPlaces: numberOfPlaces);
        
      default:
        throw RNIListViewError(
          errorCode: .invalidValue,
          description: "Invalid value for mode",
          extraDebugValues: [
            "dict": dict,
            "mode": modeString,
          ]
        );
    };
  };
};
