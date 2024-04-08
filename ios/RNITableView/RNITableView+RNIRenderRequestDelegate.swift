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
    
    let cellInstanceCount = self.cellManager.cellInstanceCount;
    
    let didRegisterAllCells =
      renderRequestView.renderRequestRegistry.count == cellInstanceCount;
      
    guard didRegisterAllCells else { return };
  };
};

