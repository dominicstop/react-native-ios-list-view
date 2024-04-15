//
//  RNITableViewListItemTargetPositionConfig.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/16/24.
//

import UIKit
import ReactNativeIosUtilities
import DGSwiftUtilities


public enum RNITableViewListItemTargetPositionConfig {

  case matchingKey(key: String);
  case matchingOrderedIndex(index: Int);
  case matchingReactIndex(index: Int);
  
  case endOfList;
  case startOfList;
};

extension RNITableViewListItemTargetPositionConfig: EnumCaseStringRepresentable {

  public var caseString: String {
    switch self {
      case .matchingKey:
        return "matchingKey";
        
      case .matchingOrderedIndex:
        return "matchingOrderedIndex";
        
      case .matchingReactIndex:
        return "matchingReactIndex";
        
      case .endOfList:
        return "endOfList";
        
      case .startOfList:
        return "startOfList";
    };
  };
};

extension RNITableViewListItemTargetPositionConfig: InitializableFromDictionary {
  
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
      case "matchingKey":
        guard let key: String = try dict.getValueFromDictionary(forKey: "key") else {
          throw RNIListViewError(
            errorCode: .guardCheckFailed,
            description: "Unable to parse value for key in dict",
            extraDebugValues: [
              "dict": dict,
              "mode": modeString,
            ]
          );
        };
        
        self = .matchingKey(key: key);
        
      case "matchingOrderedIndex":
        fallthrough; // self = .matchingOrderedIndex;
        
      case "matchingReactIndex":
        fallthrough;// self = .matchingReactIndex;
        
      case "endOfList":
        self = .endOfList;
        
      case "startOfList":
        self = .startOfList;
        
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
