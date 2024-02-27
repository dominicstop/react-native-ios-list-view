import React from 'react';
import { StyleSheet } from 'react-native';

import { RNICollectionView } from '../../native_components/RNICollectionView';

import type { CollectionViewProps, CollectionViewState } from './CollectionViewTypes';


const NATIVE_ID_KEYS = {
};

export class CollectionView extends 
  React.PureComponent<CollectionViewProps, CollectionViewState> {

  nativeRef!: RNICollectionView;

  constructor(props: CollectionViewProps){
    super(props);

    this.state = {
    };
  };

  private getProps = () => {
    const {
      ...viewProps
    } = this.props;

    return {
      // A. Group native props for `RNICollectionView`...
      nativeProps: {
        // TBA
      },

      // B. Move all the default view-related
      //    props here...
      viewProps,
    };
  };

  // Render
  // -----
  
  render(){
    const props = this.getProps();
    const state = this.state;

    return (
      <RNICollectionView
        {...props.viewProps}
        {...props.nativeProps}
        ref={r => { this.nativeRef = r! }}
        style={[styles.nativeView, props.viewProps.style]}
      />
    );
  };
};

const styles = StyleSheet.create({
  nativeView: {
  },
});