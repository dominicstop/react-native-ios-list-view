//
//  RNITableViewCell.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import UIKit
import DGSwiftUtilities


class RNITableViewCell: UITableViewCell, RNIRenderRequestDelegate {
  
  var renderRequestKey: Int?;

  var _didTriggerSetup = false;

  weak var renderRequestView: RNIRenderRequestView!;
  
  func setupIfNeeded(renderRequestView: RNIRenderRequestView){
    guard !self._didTriggerSetup else { return };
    self._didTriggerSetup = true;
    
    self.renderRequestView = renderRequestView;
    renderRequestView.renderRequestDelegate.add(self);
    
    let renderRequestKey = renderRequestView.createRenderRequest();
    self.renderRequestKey = renderRequestKey;
  };
  
  func onRenderRequestCompleted(renderRequestKey: Int, view: UIView) {
    guard self.renderRequestKey == renderRequestKey else { return };

    print(
      "RNITableViewCell.onRenderRequestCompleted",
      "\n - renderRequestKey:", renderRequestKey,
      "\n - view.bounds:", view.bounds,
      "\n"
    );
    
    view.removeFromSuperview();
    
    view.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(view);
    
    NSLayoutConstraint.activate([
      view.centerXAnchor.constraint(
        equalTo: self.centerXAnchor
      ),
      view.centerYAnchor.constraint(
        equalTo: self.centerYAnchor
      ),
      view.widthAnchor.constraint(
        equalTo: self.widthAnchor
      ),
      self.heightAnchor.constraint(
        equalToConstant: view.bounds.height
      ),
    ]);
  };
};
