//
//  RNIRenderRequestableView.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/6/24.
//

import Foundation

public protocol RNIRenderRequestableView: UIView {

  var renderRequestKey: Int { get };
  var renderRequestData: Dictionary<String, Any> { get };
  
  func notifyOnRenderRequestCompleted();
};
