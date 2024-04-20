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
  
  var _touchHandler: RCTTouchHandler?;

  public var listItem: RNITableViewListItem?;
  
  public weak var parentTableViewCell: RNITableViewCell?;
  
  public var parentTableViewContainer: RNITableView? {
    self.parentTableViewCell?.reactTableViewContainer;
  };
  
  // MARK: Properties - React Events
  // -------------------------------
  
  let onDidSetListItem = EventDispatcher("onDidSetListItem");
  
  // MARK: Properties - React Props
  // ------------------------------
  
  public var renderRequestKeyProp: Int = -1;
  
  public var reactListItem: RNITableViewListItem?;
  public var listItemProp: Dictionary<String, Any>? {
    willSet {
      guard let newValue = newValue,
            let listItem = try? RNITableViewListItem(fromDict: newValue)
      else { return };
      
      self.reactListItem = listItem;
    }
  };
  
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
      "\n - self.listItem.key:", self.listItem?.key ?? "N/A",
      "\n - self.bounds.size.width:", self.bounds.size.width,
      "\n - self.bounds.size.height:", self.bounds.size.height,
      "\n - self.frame.origin:", self.frame.origin,
      "\n - superview.className:", self.superview?.className ?? "N/A",
      "\n - superview.bounds.size:", self.superview?.bounds.size.debugDescription ?? "N/A",
      "\n - superview.frame.origin:", self.superview?.frame.origin.debugDescription ?? "N/A",
      "\n"
    );
  };
  
  // MARK: Functions
  // ---------------
  
  func _setupTouchHandlerIfNeeded(){
    guard self._touchHandler == nil,
          let appContext = self.appContext,
          let bridge = appContext.reactBridge
    else { return };
    
    let touchHandler = RCTTouchHandler(bridge: bridge);
    guard let touchHandler = touchHandler else { return };
    
    touchHandler.attach(to: self);
  };
  
  public func setListItem(
    listItem: RNITableViewListItem,
    orderedListItemIndex: Int,
    reactListItemIndex: Int
  ){
  
    self.listItem = listItem;
    
    let eventPayload: Dictionary<String, Any> = [
      "listItem": listItem.asDictionary!,
      "orderedListItemIndex": orderedListItemIndex,
      "reactListItemIndex": reactListItemIndex,
    ];
    
    self.onDidSetListItem.callAsFunction(eventPayload);
  };
  
  // MARK: React Module Functions
  // ----------------------------
  
  func notifyOnReactLayout(
    forRect layoutRect: CGRect,
    renderRequestKey: Int,
    listItem reactListItem: RNITableViewListItem?
  ){
  
    print(
      "RNITableViewCellContentView.notifyOnReactLayout",
      "\n - self.listItem.key:", self.listItem?.key ?? "N/A",
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
          
          layoutRect.height > 0,
          parentTableViewCell.renderRequestKey == renderRequestKey
    else { return };
    
    let cellManager = parentTableViewContainer.cellManager;
    
    defer {
      cellManager._debugPrintCellHeightCache();
    };
    
    let newHeight = max(
      parentTableViewContainer.minimumListCellHeightProp,
      layoutRect.height
    );
    
    if let currentListItem = self.listItem,
       let reactListItem = reactListItem,
       currentListItem != reactListItem {
      
      self.reactListItem = reactListItem;
      return;
    };
    
    let listItem: RNITableViewListItem? = {
      if let listItem = self.listItem {
        return listItem;
      };
      
      let cellForRenderRequestKey = cellManager.cellInstances.first {
        $0.renderRequestKey == renderRequestKey;
      };
      
      return cellForRenderRequestKey?.listItem;
    }();
    
    guard let listItem = listItem else { return };
    
    cellManager.setCellHeight(
      forKey: listItem.key,
      withHeight: newHeight
    );
    
    self.bounds.size.height = newHeight;
  };
  
  public func updateBounds(newSize: CGSize) {
    guard let reactBridge = self.appContext?.reactBridge else { return };
    reactBridge.uiManager.setSize(newSize, for: self);
  };
  
  // MARK: - Functions - RNIRenderRequestableView
  // --------------------------------------------
  
  public func notifyOnRenderRequestCompleted(){
    // no-op
  };
};
