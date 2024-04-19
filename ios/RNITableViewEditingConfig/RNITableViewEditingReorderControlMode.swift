//
//  RNITableViewEditingReorderControlMode.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/19/24.
//

import UIKit;
import React
import DGSwiftUtilities;


public enum RNITableViewEditingReorderControlMode: String {

  case visible;
  case hidden;
  case customView;
  case entireCell;
  
  func apply(
    toWrapper wrapper: TableViewCellReorderControlWrapper,
    cellView: RNITableViewCell,
    reactTargetView: RCTView?
  ) throws {
    guard let reorderControlView = wrapper.wrappedObject,
          let imageView = wrapper.imageView
    else {
      throw RNIListViewError(errorCode: .unexpectedNilValue);
    };
    
    @discardableResult
    func wrapCellViewInContainer(wrapperParentView: UIView) -> UIView {
    
      TableViewCellReorderControlWrapper.swizzleHitTestIfNeeded();
      let reorderControlContainer = UIView();
      
      reorderControlContainer.translatesAutoresizingMaskIntoConstraints = false;
      wrapperParentView.addSubview(reorderControlContainer);
      
      reorderControlView.translatesAutoresizingMaskIntoConstraints = false;
      reorderControlContainer.addSubview(reorderControlView);
      
      NSLayoutConstraint.activate([
        reorderControlContainer.leadingAnchor.constraint(
          equalTo: wrapperParentView.leadingAnchor
        ),
        reorderControlContainer.trailingAnchor.constraint(
          equalTo: wrapperParentView.trailingAnchor
        ),
        reorderControlContainer.topAnchor.constraint(
          equalTo: wrapperParentView.topAnchor
        ),
        reorderControlContainer.bottomAnchor.constraint(
          equalTo: wrapperParentView.bottomAnchor
        ),
      
        reorderControlContainer.leadingAnchor.constraint(
          equalTo: reorderControlContainer.leadingAnchor
        ),
        reorderControlContainer.trailingAnchor.constraint(
          equalTo: reorderControlContainer.trailingAnchor
        ),
        reorderControlContainer.topAnchor.constraint(
          equalTo: reorderControlContainer.topAnchor
        ),
        reorderControlContainer.bottomAnchor.constraint(
          equalTo: reorderControlContainer.bottomAnchor
        ),
      ]);
      
      return reorderControlContainer;
    };
    
    switch self {
      case .visible:
        return;
        
      case .hidden:
        imageView.alpha = 0.01;
        
      case .customView:
        guard let reactTargetView = reactTargetView else {
          throw RNIListViewError(errorCode: .unexpectedNilValue);
        };
        
        imageView.alpha = 0.01;
        wrapCellViewInContainer(wrapperParentView: reactTargetView)
        
      case .entireCell:
        //imageView.alpha = 0.01;
        wrapCellViewInContainer(wrapperParentView: cellView);
    };
  };
};

extension RNITableViewEditingReorderControlMode {
  
  public init?(fromWrapper wrapper: TableViewCellReorderControlWrapper){
    guard let reorderControlView = wrapper.wrappedObject,
          let imageView = wrapper.imageView
    else { return nil };
    
    if imageView.alpha <= 0.01,
       reorderControlView.superview is RNITableViewCell {
      self = .hidden;
      return;
    };
    
    if reorderControlView.superview is RNITableViewCell {
      self = .visible;
      return;
    };
    
    if let ancestorView = reorderControlView.superview?.superview,
       let reactSuperview = ancestorView as? RCTView,
       let nativeID = reactSuperview.nativeID,
       let nativeIDKey = RNITableView.NativeIDKey(rawValue: nativeID),
       nativeIDKey == .customReorderControl {
      
      self = .customView;
      return;
    };
    
    if let ancestorView = reorderControlView.superview?.superview,
       let tableViewCell = ancestorView as? RNITableViewCell,
       Int(tableViewCell.bounds.height) == Int(reorderControlView.bounds.height),
       Int(tableViewCell.bounds.width) == Int(reorderControlView.bounds.width)  {
      
      self = .entireCell;
      return;
    };
    
    return nil;
  };
};
