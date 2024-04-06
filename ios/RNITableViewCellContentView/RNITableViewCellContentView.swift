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
  
  public weak var parentTableViewContainer: RNITableView?;
  public weak var parentTableViewCell: RNITableViewCell?;
  
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
