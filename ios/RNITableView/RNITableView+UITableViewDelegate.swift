//
//  RNITableView+UITableViewDelegate.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/8/24.
//

import UIKit


extension RNITableView: UITableViewDelegate {

  public func tableView(
    _ tableView: UITableView,
    shouldIndentWhileEditingRowAt indexPath: IndexPath
  ) -> Bool {
  
    return false;
  };
  
  public func tableView(
    _ tableView: UITableView,
    editingStyleForRowAt indexPath: IndexPath
  ) -> UITableViewCell.EditingStyle {
    
    return self.isEditingConfig.defaultEditControlMode.editingStyle;
  };
  
  public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    let shouldScrollToTop = self.tableView?.scrollsToTop ?? false;
    
    block:
    if self.shouldSetCellLoadingOnScrollToTop,
       shouldScrollToTop {
      
      
      self._isScrollingToTop = true;
      self.cellManager.cellInstances.forEach {
        $0.setCellLoading(
          isLoading: true,
          shouldImmediatelyApply: false,
          shouldAnimate: false
        );
      };
    };
    
    return shouldScrollToTop;
  };
  
  public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    if self._isScrollingToTop {
      self._isScrollingToTop = false;
      
      self.cellManager.cellInstances.forEach {
        $0.setCellLoading(
          isLoading: false,
          shouldImmediatelyApply: true
        );
      };
    };
  };
};
