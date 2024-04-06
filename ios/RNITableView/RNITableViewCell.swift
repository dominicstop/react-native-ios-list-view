//
//  RNITableViewCell.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 3/1/24.
//

import UIKit
import DGSwiftUtilities


public class RNITableViewCell: UITableViewCell, RNIRenderRequestDelegate {

  public var renderRequestKey: Int?;

  var _didTriggerSetup = false;

  public weak var renderRequestView: RNIRenderRequestView?;
  public weak var reactCellContent: RNITableViewCellContentView?;
  
  // MARK: - Init + Setup
  // --------------------
  
  func _setupIfNeeded(renderRequestView: RNIRenderRequestView){
    guard !self._didTriggerSetup else { return };
    self._didTriggerSetup = true;
    
    self.renderRequestView = renderRequestView;
    renderRequestView.renderRequestDelegate.add(self);
    
    let renderRequestKey = renderRequestView.createRenderRequest();
    self.renderRequestKey = renderRequestKey;
  };
  
  
  // MARK: - Functions - RNIRenderRequestDelegate
  // --------------------------------------------
  
  public func onRenderRequestCompleted(
    renderRequestKey: Int,
    requestedView: RNIRenderRequestableView
  ) {
    guard self.renderRequestKey == renderRequestKey else { return };

    print(
      "RNITableViewCell.onRenderRequestCompleted",
      "\n - renderRequestKey:", renderRequestKey,
      "\n - requestedView.bounds:", requestedView.bounds,
      "\n"
    );
    
    requestedView.removeFromSuperview();
    
    requestedView.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(requestedView);
    
    NSLayoutConstraint.activate([
      requestedView.centerXAnchor.constraint(
        equalTo: self.centerXAnchor
      ),
      requestedView.centerYAnchor.constraint(
        equalTo: self.centerYAnchor
      ),
      requestedView.widthAnchor.constraint(
        equalTo: self.widthAnchor
      ),
      self.heightAnchor.constraint(
        equalToConstant: requestedView.bounds.height
      ),
    ]);
  };
};
