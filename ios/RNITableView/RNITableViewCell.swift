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
  
  public static var _debugShouldSetBackgroundColorToIndicateSyncStatus = false;
  
  public var indexPath: IndexPath?;
  public var renderRequestKey: Int?;
  public var listItem: RNITableViewListItem?;

  var _didTriggerSetup = false;
  var _didSetInitialSize = false;
  var _didSetupReorderControl = false;
  
  var _isCellLoading = false;
  var _shouldUpdateCellContent = true;
  
  var _didSetupLoadingIndicator = false;
  lazy var loadingIndicatorView: UIActivityIndicatorView = .init();
  
  public weak var reactTableViewContainer: RNITableView?;
  public weak var reactRenderRequestView: RNIRenderRequestView?;
  public weak var reactCellContent: RNITableViewCellContentView?;
  
  public var reorderOrderViewWrapper: TableViewCellReorderControlWrapper?;
  public weak var reorderControlContainer: UIView?;
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
    
    cellHeightConstraint.priority = .defaultHigh;
    cellHeightConstraint.isActive = true;
    self.cellHeightConstraint = cellHeightConstraint;
  };
  
  func _setupLoadingIndicatorIfNeeded(){
    guard !self._didSetupLoadingIndicator else { return };
    self._didSetupLoadingIndicator = true;
    
    let loadingIndicatorView = self.loadingIndicatorView;
    loadingIndicatorView.isHidden = true;
    
    loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false;
    self.contentView.addSubview(loadingIndicatorView);
    
    NSLayoutConstraint.activate([
      loadingIndicatorView.centerXAnchor.constraint(
        equalTo: self.contentView.centerXAnchor
      ),
      loadingIndicatorView.centerYAnchor.constraint(
        equalTo: self.contentView.centerYAnchor
      ),
      loadingIndicatorView.heightAnchor.constraint(
        equalToConstant: 75
      ),
      loadingIndicatorView.widthAnchor.constraint(
        equalToConstant: 75
      ),
    ]);
  };
  
  // MARK: - Functions - Lifecycle
  // -----------------------------
  
  public override func prepareForReuse() {
    guard self._didTriggerSetup else { return };
    
    self._resetReorderControlIfNeeded();
    self.reactCellContent?.notifyPrepareForCellReuse();
    self._applyCellLoadingStateIfNeeded(shouldAnimate: false);
    
    #if DEBUG
    self._debugUpdateSyncStatusColor();
    #endif
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
  
  // MARK: Internal Functions
  // ------------------------
  
  func _notifyWillDisplay(
    forKey key: String,
    indexPath: IndexPath
  ){
  
    self.indexPath = indexPath;
    self.setListItemIfNeeded(forKey: key);
    
    if let reactTableViewContainer = self.reactTableViewContainer,
        reactTableViewContainer._isScrollingToTop {
        
      self._isCellLoading = true;
    };
    
    self._applyCellLoadingStateIfNeeded(shouldAnimate: false);
    
    guard let reactTableViewContainer = reactTableViewContainer
    else { return };
    
    let cellManager = reactTableViewContainer.cellManager;
    let cachedHeight = cellManager.cellHeightCache[key];
    
    if let cachedHeight = cachedHeight {
      self._setCellHeight(newHeight: cachedHeight);
    };
  };
  
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
    
    self.reorderControlContainer = try? reorderControlMode.apply(
      toWrapper: reorderOrderViewWrapper,
      cellView: self,
      targetView: reorderControlTargetView
    );
  };
  
  func _resetReorderControlIfNeeded(){
    guard self._didSetupReorderControl else { return };
    self._didSetupReorderControl = false;
    
    self.reorderControlTargetView = nil;
    self.reorderOrderViewWrapper = nil;
    
    guard self.isEditingConfig.isEditing == false else { return };
    
    if let reorderControlContainer = self.reorderControlContainer {
      reorderControlContainer.removeFromSuperview();
      self.reorderControlContainer = nil;
    };    
  };
  
  func _applyCellLoadingStateIfNeeded(
    shouldAnimate: Bool? = nil,
    delay: TimeInterval = 0
  ){
    self._setupLoadingIndicatorIfNeeded();
    
    let isLoadingIndicatorVisible =
        !self.loadingIndicatorView.isHidden
      && self.loadingIndicatorView.isAnimating;
      
    let isReactContentVisible =
      Int(self.reactCellContent?.alpha ?? 0) != 0;
      
    let shouldUpdate =
         isLoadingIndicatorVisible != self._isCellLoading
      || isReactContentVisible == self._isCellLoading
      
    guard shouldUpdate else { return };
  
    let shouldAnimate = shouldAnimate ?? {
      guard let parentView = self.reactTableViewContainer,
            let globalFrame = self.globalFrame
      else { return false };
      
      return parentView.frame.intersects(globalFrame);
    }();
    
    if self._isCellLoading {
      self.loadingIndicatorView.startAnimating();
    };
    
    let updateViewsBlock = {
      self.reactCellContent?.alpha = self._isCellLoading ? 0.01 : 1;
      self.loadingIndicatorView.isHidden = !self._isCellLoading;
    };
    
    let updateViewsCompletionBlock = {
      if !self._isCellLoading {
        self.loadingIndicatorView.startAnimating();
      };
    };
    
    if shouldAnimate {
      UIView.animate(
        withDuration: 0.3,
        delay: delay,
        animations: {
          updateViewsBlock();
        },
        completion: { _ in
          updateViewsCompletionBlock();
        }
      );
    
    } else {
      updateViewsBlock();
      updateViewsCompletionBlock();
    };
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
  
  func _debugUpdateSyncStatusColor(){
    guard Self._debugShouldSetBackgroundColorToIndicateSyncStatus
    else { return };
    
    let isSynced = self.reactCellContent?.isListDataSynced ?? false;
    self.backgroundColor = isSynced
      ? .green
      : .red;
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public func setListItemIfNeeded(forKey key: String){
    guard let reactTableViewContainer = self.reactTableViewContainer,
          self._shouldUpdateCellContent
    else { return };
    
    if let reactCellContent = self.reactCellContent,
       reactCellContent.listItem?.key == key,
       reactCellContent.reactListItem?.key == key {
      
      return;
    };
    
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
  
  func setCellLoading(
    isLoading: Bool,
    shouldImmediatelyApply: Bool,
    shouldAnimate: Bool? = nil,
    delay: TimeInterval = 0
  ){
    self._isCellLoading = isLoading;
    
    if shouldImmediatelyApply {
      self._applyCellLoadingStateIfNeeded(
        shouldAnimate: shouldAnimate,
        delay: delay
      );
    };
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
    
    reactCellContent.alpha = self._isCellLoading ? 0.01 : 1;
    
    if let listItem = self.listItem {
      self.setListItemIfNeeded(forKey: listItem.key);
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
  };
};
