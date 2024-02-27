import ExpoModulesCore

public class RNICollectionViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNICollectionView")

    View(RNICollectionView.self) {
      // no-op
    }
  }
}
