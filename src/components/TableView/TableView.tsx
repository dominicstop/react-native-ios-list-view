import React from 'react';
import { StyleSheet } from 'react-native';

import { RNITableView } from '../../native_components/RNITableView';

import type { TableViewProps, TableViewState } from './TableViewTypes';
import { RNIRenderRequestView } from '../../native_components/RNIRenderRequestView';


const NATIVE_ID_KEYS = {
  renderRequest: "renderRequest",
};

export class TableView extends 
  React.PureComponent<TableViewProps, TableViewState> {

  nativeRef!: RNITableView;

  constructor(props: TableViewProps){
    super(props);

    this.state = {
    };
  };

  private getProps = () => {
    const {
      ...viewProps
    } = this.props;

    return {
      // A. Group native props for `RNITableView`...
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
      <RNITableView
        {...props.viewProps}
        {...props.nativeProps}
        ref={r => { this.nativeRef = r! }}
        style={[styles.nativeView, props.viewProps.style]}
      >
        <RNIRenderRequestView
          nativeID={NATIVE_ID_KEYS.renderRequest}
        />
      </RNITableView>
    );
  };
};

const styles = StyleSheet.create({
  nativeView: {
  },
});