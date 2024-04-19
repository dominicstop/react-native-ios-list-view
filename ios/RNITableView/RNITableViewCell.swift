//
//  RNITableViewCell.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import UIKit
import React
import DGSwiftUtilities


public class RNITableViewCell:
  UITableViewCell, RNIRenderRequestDelegate, RNITableViewCellManagerDelegate {
  
  public var indexPath: IndexPath?;
  public var renderRequestKey: Int?;
  public var listItem: RNITableViewListItem?;

  var _didTriggerSetup = false;
  var _didSetInitialSize = false;
  var _didSetupReorderControl = false;
  
  public weak var reactTableViewContainer: RNITableView?;
  public weak var reactRenderRequestView: RNIRenderRequestView?;
  public weak var reactCellContent: RNITableViewCellContentView?;
  
  public var reorderOrderViewWrapper: TableViewCellReorderControlWrapper?;
  public weak var reorderControlTargetView: UIView?;
  
  public var cellHeightConstraint: NSLayoutConstraint?;
  
  public var isEditingConfig: RNITableViewEditingConfig {
    self.reactTableViewContainer?.isEditingConfig ?? .default;
  };
  
  // MARK: - Init + Setup
  // --------------------
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier);
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder) has not been implemented");
  };
  
  func _setupIfNeeded(renderRequestView: RNIRenderRequestView){
    guard !self._didTriggerSetup,
          let reactTableViewContainer = self.reactTableViewContainer
    else { return };
    
    self._didTriggerSetup = true;
    let cellManager = reactTableViewContainer.cellManager;
    
    self.reactRenderRequestView = renderRequestView;
    renderRequestView.renderRequestDelegate.add(self);
    
    renderRequestView.createRenderRequest() {
      self.renderRequestKey = $0;
      cellManager.registerCell(self, forKey: String($0))
    };
    
    guard self.cellHeightConstraint == nil else { return };
    
    let cellHeight: CGFloat = {
      let fallbackHeight = reactTableViewContainer.minimumListCellHeightProp;
      
      guard let listItem = self.listItem else {
        return fallbackHeight;
      };
      
      let cachedHeight = cellManager.cellHeightCache[listItem.key];
      return cachedHeight ?? fallbackHeight;
    }();
    
    let cellHeightConstraint = self.contentView.heightAnchor.constraint(
      equalToConstant: cellHeight
    );
    
    cellHeightConstraint.isActive = true;
    self.cellHeightConstraint = cellHeightConstraint;
  };
  
  // MARK: - Functions - Lifecycle
  // -----------------------------
  
  public override func prepareForReuse() {
    guard self._didTriggerSetup else { return };
    
    if let reactTableViewContainer = self.reactTableViewContainer,
       !reactTableViewContainer.dragState.isDraggingOrDropping {
      
      self.alpha = 0.01;
    };
    
    self._resetReorderControlIfNeeded();
  };
  
  public override func didMoveToSuperview() {
    guard self._didTriggerSetup,
          self.superview != nil
    else { return };
    
    print("didMoveToSuperview - cellRegistry.count - \(self.reactTableViewContainer?.cellManager.cellInstanceCount ?? -1)");
  };
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    
    self._getRefToReorderControlIfNeeded();
    self._setupReorderControlIfNeeded();
  };
  
  // MARK: - Functions
  // -----------------
  
  func _getRefToReorderControlIfNeeded(){
    guard self.isEditingConfig.isEditing,
          self.reorderOrderViewWrapper == nil
    else { return };
    
    for subview in self.subviews {
      guard let wrapper = TableViewCellReorderControlWrapper(objectToWrap: subview)
      else { continue };
      
      self.reorderOrderViewWrapper = wrapper;
      break;
    };
  };
  
  func _setupReorderControlIfNeeded(){
    guard !self._didSetupReorderControl,
          self.isEditingConfig.isEditing,
          let reorderOrderViewWrapper = self.reorderOrderViewWrapper,
          reorderOrderViewWrapper.wrappedObject != nil
    else { return };
    
    self._didSetupReorderControl = true;
    
    let reorderControlTargetView: UIView? = {
      guard self.isEditingConfig.defaultReorderControlMode == .customView
      else { return nil };
      
      if let reorderControlTargetView = self.reorderControlTargetView {
        return reorderControlTargetView;
      };
      
      guard let reactCellContent = self.reactCellContent else { return nil };
      
      let match = reactCellContent.recursivelyFindSubview {
        $0.nativeID == RNITableView.NativeIDKey.customReorderControl.rawValue;
      };
      
      self.reorderControlTargetView = match;
      return match;
    }();
    
    let reorderControlMode = self.isEditingConfig.defaultReorderControlMode;
    
    try? reorderControlMode.apply(
      toWrapper: reorderOrderViewWrapper,
      cellView: self,
      targetView: reorderControlTargetView
    );
  };
  
  func _resetReorderControlIfNeeded(){
    guard self._didSetupReorderControl else { return };
    self._didSetupReorderControl = false;
    
    self.reorderOrderViewWrapper = nil;
    self.reorderControlTargetView = nil;
  };
  
  func _setCellHeight(
    newHeight: CGFloat,
    isAnimated: Bool,
    shouldUpdateTableView: Bool
  ){
    guard let reactTableViewContainer = self.reactTableViewContainer,
          let cellHeightConstraint = self.cellHeightConstraint,
          let tableView = reactTableViewContainer.tableView
    else { return };
    
    let oldHeight = cellHeightConstraint.constant;
    
    if !isAnimated {
      UIView.setAnimationsEnabled(false)
      CATransaction.begin();
      
      CATransaction.setCompletionBlock {
        UIView.setAnimationsEnabled(true);
      };
    };
    
    if shouldUpdateTableView {
      tableView.beginUpdates();
    };
    
    cellHeightConstraint.constant = newHeight;
    
    if oldHeight != newHeight {
      self.setNeedsLayout();
    };
    
    self.layoutIfNeeded();
    
    if shouldUpdateTableView {
      tableView.endUpdates();
    };
    
    if !isAnimated {
      CATransaction.commit();
    };
  };
  
  func _setCellHeight(newHeight: CGFloat){
    if !self._didSetInitialSize {
      self._setCellHeight(
        newHeight: newHeight,
        isAnimated: false,
        shouldUpdateTableView: true
      );
      
      self._didSetInitialSize = true;
      
    } else if let reactTableViewContainer = self.reactTableViewContainer,
              reactTableViewContainer.dragState.isDraggingOrDropping {
        
      self._setCellHeight(
        newHeight: newHeight,
        isAnimated: true,
        shouldUpdateTableView: false
      );
      
    } else {
      self._setCellHeight(
        newHeight: newHeight,
        isAnimated: false,
        shouldUpdateTableView: true
      );
    };
  };
  
  func _notifyWillDisplay(
    forKey key: String,
    indexPath: IndexPath
  ){
    self.indexPath = indexPath;
    self.setListItem(forKey: key);
    
    guard let reactTableViewContainer = reactTableViewContainer
    else { return };
    
    let cellManager = reactTableViewContainer.cellManager;
    let cachedHeight = cellManager.cellHeightCache[key];
    
    if let cachedHeight = cachedHeight {
      self._setCellHeight(newHeight: cachedHeight);
    };
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public func setListItem(forKey key: String){
    guard let reactTableViewContainer = self.reactTableViewContainer
    else { return };
    
    let listDataOrderedEnumerated =
      reactTableViewContainer.listDataOrdered.enumerated();
  
    let orderedListItemEnumerated = listDataOrderedEnumerated.first {
      $0.element.key == key;
    };
    
    guard let orderedListItemEnumerated = orderedListItemEnumerated
    else { return };
    
    let reactListDataEnumerated =
      reactTableViewContainer.listData.enumerated();
    
    /// index of `RNITableViewListItem` in `listDataProp`
    let reactListItemIndex: Int? = {
      let match = reactListDataEnumerated.first {
        $0.element.key == orderedListItemEnumerated.element.key;
      };
      
      return match?.offset;
    }();
    
    guard let reactListItemIndex = reactListItemIndex else { return };
    
    self.setListItem(
      listItem: orderedListItemEnumerated.element,
      orderedListItemIndex: orderedListItemEnumerated.offset,
      reactListItemIndex: reactListItemIndex
    );
  };
  
  public func setListItem(
    listItem: RNITableViewListItem,
    orderedListItemIndex: Int,
    reactListItemIndex: Int
  ){
    self.listItem = listItem;
    
    guard let reactCellContent = self.reactCellContent else { return };
    reactCellContent.setListItem(
      listItem: listItem,
      orderedListItemIndex: orderedListItemIndex,
      reactListItemIndex: reactListItemIndex
    );
  };
  
  // MARK: - Functions - RNIRenderRequestDelegate
  // --------------------------------------------
  
  public func onRenderRequestCompleted(
    renderRequestKey: Int,
    requestedView: RNIRenderRequestableView
  ) {
  
    guard self.renderRequestKey == renderRequestKey,
          let reactCellContent = requestedView as? RNITableViewCellContentView
    else { return };
    
    self.reactCellContent = reactCellContent;
    reactCellContent.parentTableViewCell = self;
    
    if let listItem = self.listItem {
      self.setListItem(forKey: listItem.key);
    };
    
    print(
      "RNITableViewCell.onRenderRequestCompleted",
      "\n - renderRequestKey:", renderRequestKey,
      "\n - requestedView.bounds:", requestedView.bounds,
      "\n - listItem.key:", self.listItem?.key ?? "N/A",
      "\n"
    );
    
    reactCellContent.removeFromSuperview();
    
    reactCellContent.translatesAutoresizingMaskIntoConstraints = false;
    self.contentView.addSubview(reactCellContent);
    
    NSLayoutConstraint.activate([
      reactCellContent.leadingAnchor.constraint(
        equalTo: self.contentView.leadingAnchor
      ),
      reactCellContent.trailingAnchor.constraint(
        equalTo: self.contentView.trailingAnchor
      ),
      reactCellContent.topAnchor.constraint(
        equalTo: self.contentView.topAnchor
      ),
    ]);
  };
  
  // MARK: - Functions: RNITableViewCellManagerDelegate
  // --------------------------------------------------
  
  public func notifyForCellHeightChange(newHeight: CGFloat) {
    self._setCellHeight(newHeight: newHeight);
    
    if let reactTableViewContainer = self.reactTableViewContainer,
       !reactTableViewContainer.dragState.isDraggingOrDropping {
      
      self.alpha = 1;
    };
  };
};
