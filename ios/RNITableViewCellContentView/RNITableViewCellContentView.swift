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

  public var listDataEntry: RNITableViewListDataEntry?;
  
  public weak var parentTableViewContainer: RNITableView?;
  public weak var parentTableViewCell: RNITableViewCell?;
  
  let onDidSetListDataEntry = EventDispatcher("onDidSetListDataEntry");

  public var renderRequestData: Dictionary<String, Any> = [:];
  public var renderRequestKey: Int = -1;
  
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
