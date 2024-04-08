//
//  RNITableViewCellManagerDelegate.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/9/24.
//

import Foundation


public protocol RNITableViewCellManagerDelegate: AnyObject {
  
  func notifyForCellHeightChange(newHeight: CGFloat);
};
