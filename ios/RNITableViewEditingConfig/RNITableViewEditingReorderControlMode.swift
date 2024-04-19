//
//  RNITableViewEditingReorderControlMode.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/19/24.
//

import UIKit;
import DGSwiftUtilities;


public enum RNITableViewEditingReorderControlMode: String {

  case visible;
  case hidden;
  case invisible;
  case center;
  case entireCell;
  case customView;
  
  public var shouldWrapReorderControl: Bool {
    switch self {
      case .center, .entireCell, .customView:
        return true;
        
      default:
        return false;
    };
  };
  
  @discardableResult
  public func apply(
    toWrapper wrapper: TableViewCellReorderControlWrapper,
    cellView: RNITableViewCell,
    targetView: UIView?
  ) throws -> UIView? {
  
    guard let reorderControlView = wrapper.wrappedObject,
          let imageView = wrapper.imageView
    else {
      throw RNIListViewError(errorCode: .unexpectedNilValue);
    };
    
    func wrapCellViewInContainer(
      wrapperParentView: UIView,
      isCentered: Bool
    ) -> UIView {
      TableViewCellReorderControlWrapper.swizzleHitTestIfNeeded();
      let reorderControlContainer = UIView();
      
      reorderControlContainer.translatesAutoresizingMaskIntoConstraints = false;
      wrapperParentView.addSubview(reorderControlContainer);
      
      reorderControlView.translatesAutoresizingMaskIntoConstraints = false;
      reorderControlContainer.addSubview(reorderControlView);
      
      var constraints: [NSLayoutConstraint] = isCentered ? [
        reorderControlContainer.centerXAnchor.constraint(
          equalTo: wrapperParentView.centerXAnchor
        ),
        reorderControlContainer.centerYAnchor.constraint(
          equalTo: wrapperParentView.centerYAnchor
        ),
        reorderControlContainer.heightAnchor.constraint(
          equalTo: wrapperParentView.heightAnchor
        ),
        reorderControlContainer.widthAnchor.constraint(
          equalTo: wrapperParentView.widthAnchor,
          multiplier: 0.5
        ),
      ] : [
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
      ];
      
      constraints += [
        reorderControlView.leadingAnchor.constraint(
          equalTo: reorderControlContainer.leadingAnchor
        ),
        reorderControlView.trailingAnchor.constraint(
          equalTo: reorderControlContainer.trailingAnchor
        ),
        reorderControlView.topAnchor.constraint(
          equalTo: reorderControlContainer.topAnchor
        ),
        reorderControlView.bottomAnchor.constraint(
          equalTo: reorderControlContainer.bottomAnchor
        ),
      ];
      
      NSLayoutConstraint.activate(constraints);
      return reorderControlContainer;
    };
    
    switch self {
      case .visible:
        imageView.alpha = 1;
        return nil;
        
      case .hidden:
        cellView.isHidden = true;
        return nil;
        
      case .invisible:
        imageView.alpha = 0.01;
        return nil;
        
      case .center:
        imageView.alpha = 0.01;
        return wrapCellViewInContainer(
          wrapperParentView: cellView,
          isCentered: true
        );
        
      case .entireCell:
        imageView.alpha = 0.01;
        return wrapCellViewInContainer(
          wrapperParentView: cellView,
          isCentered: false
        );
        
      case .customView:
        guard let targetView = targetView else {
          throw RNIListViewError(errorCode: .unexpectedNilValue);
        };
        
        imageView.alpha = 0.01;
        return wrapCellViewInContainer(
          wrapperParentView: targetView,
          isCentered: false
        );
    };
  };
  
  public func requiresCellReset(prevValue: Self) -> Bool {
    return prevValue.shouldWrapReorderControl != self.shouldWrapReorderControl;
  };
};
