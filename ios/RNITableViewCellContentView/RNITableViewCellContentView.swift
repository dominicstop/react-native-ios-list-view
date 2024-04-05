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

  public var renderRequestData: Dictionary<String, Any> = [:];
  public var renderRequestKey: Int = -1;
  
};
