import type { ViewProps } from 'react-native';


export type CollectionViewListItem = {
};

export type RNICollectionNativeViewBaseProps = {
  // TBA
  data: Array<CollectionViewListItem>;
};

export type RNICollectionNativeViewProps = 
  RNICollectionNativeViewBaseProps & ViewProps;