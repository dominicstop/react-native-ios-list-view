//
//  RNIRenderRequestView.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import UIKit
import ExpoModulesCore
import DGSwiftUtilities


public class RNIRenderRequestView: ExpoView {
  
  // MARK: Properties
  // ----------------

  public var renderRequestDelegate =
    MulticastDelegate<RNIRenderRequestDelegate>();
    
  public var currentRenderRequestKey = 0;
  public var renderRequestRegistry: Dictionary<Int, RNIRenderRequestableView> = [:];
  
  // MARK: React Event Props
  // -----------------------
  
  let onRenderRequestEvent = EventDispatcher("onRenderRequest");
  
  // MARK: Lifecycle
  // ---------------
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    guard let requestedView = subview as? RNIRenderRequestableView
    else { return };
    
    let renderRequestKey = requestedView.renderRequestKey;
    self.renderRequestRegistry[renderRequestKey] = requestedView;
    
    renderRequestDelegate.invoke {
      $0.onRenderRequestCompleted(
        renderRequestKey: renderRequestKey,
        requestedView: requestedView
      );
    };
    
    requestedView.notifyOnRenderRequestCompleted();
    
    print(
      "RNIRenderRequestView.insertReactSubview",
      "\n - renderRequestKey:", renderRequestKey,
      "\n - currentRenderRequestKey:", self.currentRenderRequestKey,
      "\n - self.frame:", self.frame,
      "\n - subview.bounds:", subview.bounds,
      "\n"
    );
  };
  
  // MARK: Functions
  // ---------------
  
  public func createRenderRequest(
    onRenderRequestKeyCreateBlock: (Int) -> Void
  ) {
    let renderRequestKey = self.currentRenderRequestKey;
    self.currentRenderRequestKey += 1;
    
    onRenderRequestKeyCreateBlock(renderRequestKey);
    let match = self.renderRequestRegistry[renderRequestKey];
    
    if let match = match {
      self.renderRequestDelegate.invoke {
        $0.onRenderRequestCompleted(
          renderRequestKey: renderRequestKey,
          requestedView: match
        );
      };
    
    } else {
      self.onRenderRequestEvent.callAsFunction([
        "renderRequestKey": renderRequestKey,
      ]);
    };
    
    print(
      "RNIRenderRequestView.createRenderRequest",
      "\n - renderRequestKey:", renderRequestKey,
      "\n - renderRequestRegistry.count:", self.renderRequestRegistry.count,
      "\n"
    );
  };
};
