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

  case matchingKey(key: String, section: String?);
  case matchingOrderedIndex(index: Int, section: String?);
  case matchingReactIndex(index: Int, section: String?);
  
  case endOfList(section: String?);
  case startOfList(section: String?);
  
  public var targetSectionID: RNITableViewListSectionIdentifier? {
    switch self {
      case let .matchingKey(_, section):
        return section;
        
      case let .matchingOrderedIndex(_, section):
        return section;
        
      case let .matchingReactIndex(_, section):
        return section;
        
      case let .endOfList(section):
        return section;
        
      case let .startOfList(section):
        return section;
    };
  };
  
  public func getMatchingItemIdentifier(
    inSnapshot snapshot: RNITableViewDataSourceSnapshot,
    withReactListItems reactListItems: [RNITableViewListItem]
  ) throws -> RNITableViewListItemIdentifier? {
    
    let sectionFallback = snapshot.sectionIdentifiers.first;
    let targetSection = self.targetSectionID ?? sectionFallback;
    
    guard let targetSection = targetSection else {
      throw RNIListViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get targetSection"
      );
    };
    
    let itemsForSection = snapshot.itemIdentifiers(inSection: targetSection);
    
    switch self {
      case let .matchingKey(key, _):
        return itemsForSection.first {
          $0 == key;
        };
        
      case let .matchingOrderedIndex(index, _):
        return itemsForSection[safeIndex: index];
        
      case let .matchingReactIndex(index, _):
         return reactListItems[safeIndex: index]?.key;
         
      case .endOfList:
        return itemsForSection.last;
        
      case .startOfList:
        return itemsForSection.first;
    };
  };
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
    
    let section = try? dict.getValueFromDictionary(
      forKey: "key",
      type: String.self
    );
    
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
        
        self = .matchingKey(key: key, section: section);
        
      case "matchingOrderedIndex":
        fatalError("To be impl."); // self = .matchingOrderedIndex;
        
      case "matchingReactIndex":
        fatalError("To be impl.");// self = .matchingReactIndex;
        
      case "endOfList":
        self = .endOfList(section: section);
        
      case "startOfList":
        self = .startOfList(section: section);
        
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
