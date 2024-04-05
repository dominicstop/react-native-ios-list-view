//
//  RNIRenderRequestDelegate.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/6/24.
//

import Foundation


public protocol RNIRenderRequestDelegate {
  
  func onRenderRequestCompleted(
    renderRequestKey: Int,
    requestedView: RNIRenderRequestableView
  );
};
