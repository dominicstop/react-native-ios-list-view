//
//  RNITableViewCellManager.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/8/24.
//

import Foundation


final public class RNITableViewCellManager {

  public weak var reactTableViewWrapper: RNITableView?;
  
  public var maxInactiveCellCount = 30;

  public var cellRegistry = NSMapTable<NSString, RNITableViewCell>.init(
    keyOptions: .copyIn,
    valueOptions: .strongMemory
  );
  
  public var cellHeightCache: Dictionary<String, CGFloat> = [:];
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var cellInstances: [RNITableViewCell] {
    let items = self.cellRegistry.objectEnumerator()?.allObjects ?? [];
    return items as! [RNITableViewCell];
  };
  
  public var cellInstanceCount: Int {
    self.cellInstances.count;
  };
  
  public var cellInstancesLoading: [RNITableViewCell] {
    self.cellInstances.filter {
      $0._isCellLoading;
    };
  };
  
  public var cellInstancesInUse: [RNITableViewCell] {
    self.cellInstances.filter {
      $0._isCellInUse;
    };
  };
  
  public var cellInstancesInactive: [RNITableViewCell] {
    self.cellInstances.filter {
      !$0._isCellInUse;
    };
  };
  
  // MARK: - Init
  // ------------
  
  public init(reactTableViewWrapper: RNITableView) {
    self.reactTableViewWrapper = reactTableViewWrapper;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func purgeInactiveCellsIfNeeded(){
    var cellInstancesInactive = self.cellInstancesInactive;
    
    guard cellInstancesInactive.count > 0,
          cellInstancesInactive.count > self.maxInactiveCellCount
    else { return };
    
    var cellsToRemove: [RNITableViewCell] = [];
    
    while cellInstancesInactive.count > self.maxInactiveCellCount {
      guard let cell = cellInstancesInactive.popLast() else { break };
      cellsToRemove.append(cell);
    };
    
    guard cellsToRemove.count > 0 else { return };
    
    cellsToRemove.forEach {
      guard let key = $0.renderRequestKey else { return };
      self.cellRegistry.removeObject(forKey: String(key) as NSString);
    };
  };
  
  public func registerCell(_ cell: RNITableViewCell, forKey key: String){
    self.purgeInactiveCellsIfNeeded();
    
    guard self.cellRegistry.object(forKey: key as NSString) == nil
    else { return };
    
    self.cellRegistry.setObject(cell, forKey: key as NSString);
  };
  
  public func setCellHeight(
    forKey key: String,
    withHeight newHeight: CGFloat
  ){
    let oldHeight = self.cellHeightCache[key] ?? 0;
    
    guard newHeight > 0 else { return };
    self.cellHeightCache[key] = newHeight;
    
    let cellForKey = self.cellInstances.first {
      $0.listItem?.key == key;
    };
    
    guard let cellForKey = cellForKey else { return };
    
    let shouldNotify: Bool = {
      if oldHeight != newHeight {
        return true;
      };
      
      if cellForKey.bounds.height != newHeight {
        return true;
      };
      
      if cellForKey.cellHeightConstraint?.constant != newHeight {
        return true;
      };
      
      return false;
    }();
    
    guard shouldNotify else { return };
    cellForKey.notifyForCellHeightChange(newHeight: newHeight);
  };
  
  public func cellForItemIdentifier(
    _ itemID: RNITableViewListItemIdentifier
  ) -> RNITableViewCell? {
  
    return self.cellInstances.first {
      $0.listItem?.key == itemID;
    };
  };
  
  func _debugPrintCellHeightCache(){
    var string = "RNITableViewCellManager._debugPrintCellHeightCache";
    string += "\n - count: \(self.cellHeightCache.count)";
    
    string += self.cellHeightCache.enumerated().reduce("") {
      $0 + "\n \($1.offset) - key: \($1.element.key) - height: \($1.element.value)";
    };
    
    print(string);
  };
};
