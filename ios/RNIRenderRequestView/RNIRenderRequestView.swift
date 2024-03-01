//
//  RNIRenderRequestView.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import UIKit
import ExpoModulesCore
import DGSwiftUtilities

protocol RNIRenderRequestDelegate {
  
  func onRenderRequestCompleted(
    renderRequestKey: Int,
    view: UIView
  );
};

class RNIRenderRequestView: ExpoView {

  var renderRequestDelegate =
    MulticastDelegate<RNIRenderRequestDelegate>();

  var currentRenderRequestKey = 0;
  var renderRequestRegistry: Dictionary<Int, UIView> = [:];

  let onRenderRequestEvent = EventDispatcher("onRenderRequest");
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    subview.removeFromSuperview();
    
    self.renderRequestRegistry[self.currentRenderRequestKey] = subview;
    
    // temp. encode/decode data using `nativeID`
    let renderRequestKey = Int(subview.nativeID!)!;
    
    renderRequestDelegate.invoke {
      $0.onRenderRequestCompleted(
        renderRequestKey: renderRequestKey,
        view: subview
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
  
  func createRenderRequest() -> Int {
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
