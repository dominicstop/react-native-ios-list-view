//
//  RNITableViewDragState.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/13/24.
//

import Foundation


public enum RNITableViewDragState {
  case idle;
  case dragging;
  case dropping;
  case dropped;
  
  public var isDraggingOrDropping: Bool {
    switch self {
      case .dragging, .dropping:
        return true;
      default:
        return false;
    };
  };
};
