import ExpoModulesCore

public class RNITableViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNITableView");

    View(RNITableView.self) {
      Prop("listData"){
        $0.listDataProp = $1;
      };
    }
  };
};
