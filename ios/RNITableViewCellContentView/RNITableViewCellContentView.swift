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
  var _didSetup = false;
  var _didSetInitialSize = false;
  var _isListDataSynced = false;
  
  weak var _shadowView: RCTShadowView?;

  public var listItem: RNITableViewListItem?;
  public var orderedListItemIndex: Int?;
  public var reactListItemIndex: Int?;
  
  public weak var parentTableViewCell: RNITableViewCell?;
  
  public var parentTableViewContainer: RNITableView? {
    self.parentTableViewCell?.reactTableViewContainer;
  };
  
  var layoutMetrics: RCTLayoutMetrics? {
    self._shadowView?.layoutMetrics;
  };
  
  public var isListDataSynced: Bool {
    guard let nativeListItem = self.listItem,
          let reactListItem = self.reactListItem
    else {
      return false;
    };
    
    return nativeListItem.key == reactListItem.key;
  };
  
  var _shouldUpdateCellContent: Bool {
    return self.parentTableViewCell?._shouldUpdateCellContent ?? true;
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
      self._setCellHeightIfNeeded();
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
    self._setCellHeightIfNeeded();
    
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
  
  public func notifyPrepareForCellReuse(){
    self._isListDataSynced = false;
  
    self.orderedListItemIndex = nil;
    self.reactListItemIndex = nil;
    self.reactListItem = nil;
  };
  
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
  
  func _setCellHeightIfNeeded(){
    let shouldUpdateCellHeight =
         self.isListDataSynced
      || !self._didSetInitialSize
      && self._shouldUpdateCellContent;
      
    guard shouldUpdateCellHeight,
          let listItem = self.reactListItem,
          let parentTableViewContainer = self.parentTableViewContainer,
          let layoutMetrics = self.layoutMetrics,
          
          layoutMetrics.frame.height > 0
    else {
      return;
    };
    
    let oldHeight = parentTableViewContainer.bounds.size.height;
    
    let newHeight = max(
      parentTableViewContainer.minimumListCellHeightProp,
      layoutMetrics.frame.height
    );
    
    let didHeightChange: Bool = {
      let delta = abs(newHeight - oldHeight);
      return delta > 0;
    }();
    
    guard didHeightChange else { return };
    let cellManager = parentTableViewContainer.cellManager;
    
    if !self._didSetInitialSize {
      self._didSetInitialSize = true;
    };
    
    cellManager.setCellHeight(
      forKey: listItem.key,
      withHeight: newHeight
    );
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
  
  func _syncIfNeeded(){
    #if DEBUG
    self.parentTableViewCell?._debugUpdateSyncStatusColor();
    #endif
    
    guard self._shouldUpdateCellContent else { return };
    let isListDataSynced = self.isListDataSynced;
    
    if !self._isListDataSynced && isListDataSynced {
      self._isListDataSynced = true;
      self._notifyOnListDataSynced();
    };
  
    guard !isListDataSynced,
          let listItem = self.listItem,
          let orderedListItemIndex = self.orderedListItemIndex,
          let reactListItemIndex = self.reactListItemIndex
    else { return };

    let eventPayload: Dictionary<String, Any> = [
      "listItem": listItem.asDictionary!,
      "orderedListItemIndex": orderedListItemIndex,
      "reactListItemIndex": reactListItemIndex,
    ];
    
    self.onDidSetListItem.callAsFunction(eventPayload);
  };
  
  func _notifyOnListDataSynced(){
    if let parentTableViewCell = self.parentTableViewCell,
       parentTableViewCell._isCellLoading {
      
      parentTableViewCell.setCellLoading(
        isLoading: false,
        shouldImmediatelyApply: true,
        delay: 0.1
      );
    };
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
  
    guard self._shouldUpdateCellContent,
          let parentTableViewCell = self.parentTableViewCell,
          parentTableViewCell.renderRequestKey == renderRequestKey
    else { return };
  
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
    
    if let reactListItem = reactListItem {
      self.reactListItem = reactListItem;
    };
    
    guard self.isListDataSynced else {
      self._syncIfNeeded();
      return;
    };
    
    guard let parentTableViewContainer = self.parentTableViewContainer,
          let listItem = self.listItem
    else { return };
    
    let cellManager = parentTableViewContainer.cellManager;
    
    let newHeight = max(
      parentTableViewContainer.minimumListCellHeightProp,
      layoutRect.height
    );
    
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
