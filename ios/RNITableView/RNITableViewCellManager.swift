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
  
  // MARK: - Init
  // ------------
  
  public init(reactTableViewWrapper: RNITableView) {
    self.reactTableViewWrapper = reactTableViewWrapper;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func registerCell(_ cell: RNITableViewCell, forKey key: String){
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
      $0.listDataEntry?.key == key;
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
  
  func _debugPrintCellHeightCache(){
    var string = "RNITableViewCellManager._debugPrintCellHeightCache";
    string += "\n - count: \(self.cellHeightCache.count)";
    
    string += self.cellHeightCache.enumerated().reduce("") {
      $0 + "\n \($1.offset) - key: \($1.element.key) - height: \($1.element.value)";
    };
    
    print(string);
  };
};
