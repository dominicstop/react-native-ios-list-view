

export type RNITableViewListItemTargetPositionConfig = {
  mode: 'matchingKey';
  key: string;
} | {
  // to be impl.
  mode: 'matchingOrderedIndex' & never;
  index: number & never;
} | {
  // to be impl.
  mode: 'matchingReactIndex' & never;
  index: number & never;
} | {
  mode: 'endOfList' | 'startOfList';
} & {
  targetSection?: string;
};