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
  
  var _isSynced = false;
  var _didSetup = false;
  var _didSetSize = false;
  weak var _shadowView: RCTShadowView?;

  public var listItem: RNITableViewListItem?;
  public var orderedListItemIndex: Int?;
  public var reactListItemIndex: Int?;
  
  public weak var parentTableViewCell: RNITableViewCell?;
  
  public var parentTableViewContainer: RNITableView? {
    self.parentTableViewCell?.reactTableViewContainer;
  };
  
  
  var isCellDataAndSizeSynced: Bool {
       self._didSetSize
    || self.listItem == self.reactListItem;
  };
  
  
  var layoutMetrics: RCTLayoutMetrics? {
    self._shadowView?.layoutMetrics;
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
      let oldListItem = self.reactListItem;
      
      guard let newValue = newValue,
            let newListItem = try? RNITableViewListItem(fromDict: newValue),
            oldListItem != newListItem
      else { return };
      
      self.reactListItem = listItem;
      self._syncIfNeeded();
    }
  };
  
  // MARK: Properties - RNIRenderRequestableView
  // -------------------------------------------

  public var renderRequestData: Dictionary<String, Any> = [:];
  
  public var renderRequestKey: Int {
    self.renderRequestKeyProp;
  };
  
  // MARK: - Lifecycle
  // -----------------
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    
    #if DEBUG
    self.parentTableViewCell?._debugUpdateSyncStatusColor();
    #endif
    
    print(
      "RNITableViewCellContentView.layoutSubviews",
      "\n - self.renderRequestKey:", self.renderRequestKey,
      "\n - self.listItem.key:", self.listItem?.key ?? "N/A",
      "\n - self.bounds.size.width:", self.bounds.size.width,
      "\n - self.bounds.size.height:", self.bounds.size.height,
      "\n - self._shadowView.layoutMetrics.frame:", self._shadowView?.layoutMetrics.frame ?? .zero,
      "\n - self._shadowView.layoutMetrics.contentFrame:", self._shadowView?.layoutMetrics.contentFrame ?? .zero,
      "\n - self.frame.origin:", self.frame.origin,
      "\n - superview.className:", self.superview?.className ?? "N/A",
      "\n - superview.bounds.size:", self.superview?.bounds.size.debugDescription ?? "N/A",
      "\n - superview.frame.origin:", self.superview?.frame.origin.debugDescription ?? "N/A",
      "\n"
    );
  };
  
  public override func didMoveToWindow() {
    guard self.window != nil else { return };
    self._setupIfNeeded();
  };
  
  // MARK: Functions
  // ---------------
  
  func _setupIfNeeded(){
    guard !self._didSetup,
          let bridge = self.appContext?.reactBridge,
          let uiManager = bridge.uiManager
    else { return };
    self._didSetup = true;
    
    RCTExecuteOnUIManagerQueue {
      let shadowView = uiManager.shadowView(forReactTag: self.reactTag);
      self._shadowView = shadowView;
    };
  };
  
  func _setupTouchHandlerIfNeeded(){
    guard self._touchHandler == nil,
          let appContext = self.appContext,
          let bridge = appContext.reactBridge
    else { return };
    
    let touchHandler = RCTTouchHandler(bridge: bridge);
    guard let touchHandler = touchHandler else { return };
    
    touchHandler.attach(to: self);
  };
  
  func _checkIfSynced() -> Bool {
       self._isSynced
    || self._didSetSize
    || self.listItem == self.reactListItem;
  };
  
  func _syncIfNeeded(){
    let isSynced = self._checkIfSynced();
    
    #if DEBUG
    self.parentTableViewCell?._debugUpdateSyncStatusColor();
    #endif
    
    guard !isSynced,
          let listItem = self.listItem,
          let orderedListItemIndex = self.orderedListItemIndex,
          let reactListItemIndex = self.reactListItemIndex
    else { return };
    
    self._isSynced = isSynced;

    let eventPayload: Dictionary<String, Any> = [
      "listItem": listItem.asDictionary!,
      "orderedListItemIndex": orderedListItemIndex,
      "reactListItemIndex": reactListItemIndex,
    ];
    
    self.onDidSetListItem.callAsFunction(eventPayload);
  };
  
  public func setListItem(
    listItem: RNITableViewListItem,
    orderedListItemIndex: Int,
    reactListItemIndex: Int
  ){
  
    self.listItem = listItem;
    self.orderedListItemIndex = orderedListItemIndex;
    self.reactListItemIndex = reactListItemIndex;
    
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
      "\n - self.reactContentFrame:", self.reactContentFrame,
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
      self._syncIfNeeded();
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
