import { ViewProps } from "react-native";
// import { RNITableViewBaseProps } from "../../native_components/RNITableView";

// export type TableViewInheritedProps 

export type TableViewBaseProps = {
  // TBA
};

export type TableViewProps = 
  // & TableViewInheritedProps
  & TableViewBaseProps 
  & ViewProps;

export type TableViewState = {
  // TBA
};