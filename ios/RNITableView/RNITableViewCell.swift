//
//  RNITableViewCell.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import UIKit
import DGSwiftUtilities


public class RNITableViewCell:
  UITableViewCell, RNIRenderRequestDelegate, RNITableViewCellManagerDelegate {
  
  public var renderRequestKey: Int?;
  public var listDataEntry: RNITableViewListDataEntry?;

  var _didTriggerSetup = false;
  
  public weak var reactTableViewContainer: RNITableView?;
  public weak var reactRenderRequestView: RNIRenderRequestView?;
  public weak var reactCellContent: RNITableViewCellContentView?;
  
  public var cellHeightConstraint: NSLayoutConstraint?;
  
  // MARK: - Init + Setup
  // --------------------
  
  func _setupIfNeeded(renderRequestView: RNIRenderRequestView){
    guard !self._didTriggerSetup,
          let reactTableViewContainer = self.reactTableViewContainer
    else { return };
    
    self._didTriggerSetup = true;
    
    self.reactRenderRequestView = renderRequestView;
    renderRequestView.renderRequestDelegate.add(self);
    
    renderRequestView.createRenderRequest() {
      self.renderRequestKey = $0;
    };
    
    let cellHeightConstraint = self.heightAnchor.constraint(
      equalToConstant: reactTableViewContainer.minimumListCellHeightProp
    );
    
    cellHeightConstraint.isActive = true;
    self.cellHeightConstraint = cellHeightConstraint;
  };
  
  // MARK: - Functions
  // -----------------
  
  func _setCellHeight(newHeight: CGFloat){
    guard let cellHeightConstraint = self.cellHeightConstraint else { return };
    
    cellHeightConstraint.constant = newHeight;
    self.layoutIfNeeded();
  };
  
  func _notifyWillDisplay(forKey key: String){
    self.setListDataEntry(forKey: key);
    
    guard let reactTableViewContainer = reactTableViewContainer
    else { return };
    
    let cellManager = reactTableViewContainer.cellManager;
    let cachedHeight = cellManager.cellHeightCache[key];
    
    guard let cachedHeight = cachedHeight else { return };
    self._setCellHeight(newHeight: cachedHeight);
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public func setListDataEntry(forKey key: String){
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
    
    /// index of `RNITableViewListDataEntry` in `listDataProp`
    let reactListItemIndex: Int? = {
      let match = reactListDataEnumerated.first {
        $0.element.key == orderedListItemEnumerated.element.key;
      };
      
      return match?.offset;
    }();
    
    guard let reactListItemIndex = reactListItemIndex else { return };
    
    self.setListDataEntry(
      listDataEntry: orderedListItemEnumerated.element,
      orderedListDataEntryIndex: orderedListItemEnumerated.offset,
      reactListDataEntryIndex: reactListItemIndex
    );
  };
  
  public func setListDataEntry(
    listDataEntry: RNITableViewListDataEntry,
    orderedListDataEntryIndex: Int,
    reactListDataEntryIndex: Int
  ){
    self.listDataEntry = listDataEntry;
    
    guard let reactCellContent = self.reactCellContent else { return };
    reactCellContent.setListDataEntry(
      listDataEntry: listDataEntry,
      orderedListDataEntryIndex: orderedListDataEntryIndex,
      reactListDataEntryIndex: reactListDataEntryIndex
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
    
    if let listDataEntry = self.listDataEntry {
      self.setListDataEntry(forKey: listDataEntry.key);
    };
    
    print(
      "RNITableViewCell.onRenderRequestCompleted",
      "\n - renderRequestKey:", renderRequestKey,
      "\n - requestedView.bounds:", requestedView.bounds,
      "\n - listDataEntry.key:", self.listDataEntry?.key ?? "N/A",
      "\n"
    );
    
    reactCellContent.removeFromSuperview();
    
    reactCellContent.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(reactCellContent);
    
    NSLayoutConstraint.activate([
      reactCellContent.leadingAnchor.constraint(
        equalTo: self.leadingAnchor
      ),
      reactCellContent.trailingAnchor.constraint(
        equalTo: self.trailingAnchor
      ),
      reactCellContent.topAnchor.constraint(
        equalTo: self.topAnchor
      ),
    ]);
  };
  
  // MARK: - Functions: RNITableViewCellManagerDelegate
  // --------------------------------------------------
  
  public func notifyForCellHeightChange(newHeight: CGFloat) {
    self._setCellHeight(newHeight: newHeight);
  };
};
