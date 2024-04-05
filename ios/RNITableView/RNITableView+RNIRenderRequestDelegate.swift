//
//  RNITableView+RNIRenderRequestDelegate.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/6/24.
//

import Foundation

extension RNITableView: RNIRenderRequestDelegate {

  public func onRenderRequestCompleted(
    renderRequestKey: Int,
    requestedView: RNIRenderRequestableView
  ) {
    let renderRequestView = self.renderRequestView!;
    
    let didRegisterAllCells =
      renderRequestView.renderRequestRegistry.count == self.cellInstanceCount;
      
    guard didRegisterAllCells else { return };
  };
};

