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
  
  public func createRenderRequest() -> Int {
    let renderRequestKey = self.currentRenderRequestKey;
    self.currentRenderRequestKey += 1;
    
    self.onRenderRequestEvent.callAsFunction([
      "renderRequestKey": renderRequestKey,
    ]);
    
    print(
      "RNIRenderRequestView.createRenderRequest",
      "\n - renderRequestKey:", renderRequestKey,
      "\n - renderRequestRegistry.count:", self.renderRequestRegistry.count,
      "\n"
    );
    
    return renderRequestKey;
  };
};
