//
//  RNITableViewListItem.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/4/24.
//

import Foundation
import DGSwiftUtilities


public typealias RNITableViewListSectionIdentifier = String;
public typealias RNITableViewListItemIdentifier = String;

public struct RNITableViewListItem: Hashable, Encodable {
  public var key: RNITableViewListItemIdentifier;
};

extension RNITableViewListItem: InitializableFromDictionary {
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let key = try? dict.getValueFromDictionary(
      forKey: "key",
      type: String.self
    );
  
    guard let key = key else {
      throw RNIListViewError(errorCode: .unexpectedNilValue);
    };
    
    self.key = key;
  };
};