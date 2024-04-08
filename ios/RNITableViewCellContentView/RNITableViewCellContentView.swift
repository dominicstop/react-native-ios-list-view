//
//  RNITableViewCellContentView.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/5/24.
//

import UIKit
import ExpoModulesCore
import ReactNativeIosUtilities
import DGSwiftUtilities


public class RNITableViewCellContentView: ExpoView, RNIRenderRequestableView {

  // MARK: Properties
  // ----------------

  public var listDataEntry: RNITableViewListDataEntry?;
  
  public weak var parentTableViewCell: RNITableViewCell?;
  
  public var parentTableViewContainer: RNITableView? {
    self.parentTableViewCell?.reactTableViewContainer;
  };
  
  // MARK: Properties - React Events
  // -------------------------------
  
  let onDidSetListDataEntry = EventDispatcher("onDidSetListDataEntry");
  
  // MARK: Properties - React Props
  // ------------------------------
  
  public var renderRequestKeyProp: Int = -1;
  
  // MARK: Properties - RNIRenderRequestableView
  // -------------------------------------------

  public var renderRequestData: Dictionary<String, Any> = [:];
  
  public var renderRequestKey: Int {
    self.renderRequestKeyProp;
  };
  
  //
  //
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    print(
      "RNITableViewCellContentView.layoutSubviews",
      "\n - self.renderRequestKey:", self.renderRequestKey,
      "\n - self.listDataEntry.key:", self.listDataEntry?.key ?? "N/A",
      "\n - self.bounds.size.width:", self.bounds.size.width,
      "\n - self.bounds.size.height:", self.bounds.size.height,
      "\n - self.frame.origin:", self.frame.origin,
      "\n - superview.className:", self.superview?.className ?? "N/A",
      "\n - superview.bounds.size:", self.superview?.bounds.size.debugDescription ?? "N/A",
      "\n - superview.frame.origin:", self.superview?.frame.origin.debugDescription ?? "N/A",
      "\n"
    );
  };
  
  // MARK: React Module Functions
  // ----------------------------
  
  func notifyOnReactLayout(forRect layoutRect: CGRect){
    // WIP - To be impl.
    print(
      "RNITableViewCellContentView.notifyOnReactLayout",
      "\n - self.listDataEntry.key:", self.listDataEntry?.key ?? "N/A",
      "\n - self.renderRequestKey:", self.renderRequestKey,
      "\n - layoutRect.size:", layoutRect.size,
      "\n - layoutRect.origin:", layoutRect.origin,
      "\n - self.bounds.size:", self.bounds.size,
      "\n - self.frame.size:", self.frame.size,
      "\n - self.frame.origin:", self.frame.origin,
      "\n"
    );
    
    guard let parentTableViewContainer = self.parentTableViewContainer,
          let parentTableViewCell = self.parentTableViewCell,
          let cellHeightConstraint = parentTableViewCell.cellHeightConstraint,
          
          layoutRect.height > 0,
          layoutRect.height >= parentTableViewContainer.minimumListCellHeightProp
    else { return };
    
    cellHeightConstraint.constant = layoutRect.height;
    parentTableViewCell.layoutIfNeeded();
  };
  
  // MARK: Functions
  // ---------------
  
  public func setListDataEntry(
    listDataEntry: RNITableViewListDataEntry,
    orderedListDataEntryIndex: Int,
    reactListDataEntryIndex: Int
  ){
  
    self.listDataEntry = listDataEntry;
    
    let eventPayload: Dictionary<String, Any> = [
      "listDataEntry": listDataEntry.asDictionary!,
      "orderedListDataEntryIndex": orderedListDataEntryIndex,
      "reactListDataEntryIndex": reactListDataEntryIndex,
    ];
    
    self.onDidSetListDataEntry.callAsFunction(eventPayload);
  };
  
  public func updateBounds(newSize: CGSize) {
    guard let reactBridge = self.appContext?.reactBridge else { return };
    reactBridge.uiManager.setSize(newSize, for: self);
  };
};
