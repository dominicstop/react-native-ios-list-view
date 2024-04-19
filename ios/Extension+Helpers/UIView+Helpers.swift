//
//  UIView+Helpers.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/20/24.
//

import UIKit

public extension UIView {
  
  func recursivelyFindSubview(
    where predicate: (_ subview: UIView) -> Bool
  ) -> UIView? {
    
    for subview in self.subviews {
      if predicate(subview) {
        return subview;
      };
    };
    
    for subview in self.subviews {
      if let match = subview.recursivelyFindSubview(where: predicate) {
        return match;
      };
    };
    
    return nil;
  };
};
