import { ViewProps } from "react-native";
// import { RNICollectionViewBaseProps } from "../../native_components/RNICollectionView";

// export type CollectionViewInheritedProps 

export type CollectionViewBaseProps = {
  // TBA
};

export type CollectionViewProps = 
  // & CollectionViewInheritedProps
  & CollectionViewBaseProps 
  & ViewProps;

export type CollectionViewState = {
  // TBA
};