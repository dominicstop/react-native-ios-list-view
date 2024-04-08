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
    self.cellRegistry.setObject(cell, forKey: key as NSString);
  };
  
  public func setCellHeight(
    forCell cell: RNITableViewCell,
    size: CGSize
  ){
    guard let reactTableViewWrapper = self.reactTableViewWrapper,
          let listDataEntry = cell.listDataEntry
    else { return };
    
    let newHeight = size.height;
    let tableViewWidth = reactTableViewWrapper.bounds.width;
    
    guard tableViewWidth > 0,
          newHeight > 0,
          
          cell.bounds.width == tableViewWidth
    else { return };
    
    self.cellHeightCache[listDataEntry.key] = newHeight;
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
