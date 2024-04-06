import { ViewProps } from 'react-native';
import { RNITableViewCellContentNativeViewBaseProps } from './RNITableViewCellContentNativeViewTypes';


export type RNITableViewCellContentViewInheritedRequiredProps = Pick<RNITableViewCellContentNativeViewBaseProps,
 | 'renderRequestKey'
>;

export type RNITableViewCellContentViewInheritedOptionalProps = Partial<Pick<RNITableViewCellContentNativeViewBaseProps,
 | 'onDidSetListDataEntry'
>>;

export type RNITableViewCellContentViewInheritedProps = 
  & RNITableViewCellContentViewInheritedRequiredProps
  & RNITableViewCellContentViewInheritedOptionalProps;

export type RNITableViewCellContentViewBaseProps = {
};

export type RNITableViewCellContentViewProps = 
    RNITableViewCellContentViewBaseProps 
  & RNITableViewCellContentViewInheritedProps
  & ViewProps;

export type RNITableViewCellContentViewState = {
};