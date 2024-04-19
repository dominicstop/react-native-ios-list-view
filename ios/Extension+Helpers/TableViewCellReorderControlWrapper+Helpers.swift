//
//  TableViewCellReorderControlWrapper+Helpers.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/19/24.
//

import UIKit
import DGSwiftUtilities


public extension TableViewCellReorderControlWrapper {
  
  var imageView: UIImageView? {
    self.wrappedObject?.recursivelyGetAllSubviews.reduce(into: nil){
      $0 = $0 ?? $1 as? UIImageView;
    };
  };
};

