//
//  RNITableViewCellManager.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/8/24.
//

import Foundation


final public class RNITableViewCellManager {

  public weak var reactTableViewWrapper: RNITableView?;

  public var cellRegistry = NSMapTable<NSString, RNITableViewCell>.init(
    keyOptions: .copyIn,
    valueOptions: .weakMemory
  );
  
  public var cellInstances: [RNITableViewCell] {
    let items = self.cellRegistry.objectEnumerator()?.allObjects ?? [];
    return items as! [RNITableViewCell];
  };
  
  public var cellInstanceCount: Int {
    self.cellInstances.count;
  };
  
  public init(reactTableViewWrapper: RNITableView) {
    self.reactTableViewWrapper = reactTableViewWrapper;
  };
  
  public func registerCell(_ cell: RNITableViewCell, forKey key: String){
    self.cellRegistry.setObject(cell, forKey: key as NSString);
  };
};
