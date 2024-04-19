
import UIKit
import ExpoModulesCore
import ReactNativeIosUtilities


public class RNITableViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNITableView");
    
    AsyncFunction("requestToMoveListItem") {
      (reactTag: Int, args: Dictionary<String, Any>, promise: Promise) in
      
      DispatchQueue.main.async {
        do {
          let reactTableView = try RNIModuleHelpers.getView(
            withErrorType: RNIListViewError.self,
            forNode: reactTag,
            type: RNITableView.self
          );
          
          try reactTableView.requestToMoveListItem(usingDict: args);
        
        } catch let error {
          promise.reject(error);
          return;
        };
      };
    };

    View(RNITableView.self) {
      Prop("listData"){
        $0.listDataProp = $1;
      };
      
      Prop("minimumListCellHeight"){
        $0.minimumListCellHeightProp = $1;
      };
      
      Prop("isEditingConfig"){
        $0.isEditingConfigProps = $1;
      };
    }
  };
};
