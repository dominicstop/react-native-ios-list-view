//
//  RNIListViewError.swift
//  ReactNativeIosListView
//
//  Created by Dominic Go on 4/4/24.
//

import Foundation
import ReactNativeIosUtilities
import DGSwiftUtilities



public struct RNIRNIListViewErrorMetadata: ErrorMetadata {
  public static var domain: String? = "react-native-ios-list-view";
  public static var parentType: String? = nil;
};

public typealias RNIListViewError = RNIError<RNIRNIListViewErrorMetadata>;
