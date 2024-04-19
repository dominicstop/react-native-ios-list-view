
export type RNITableViewEditingReorderControlMode  =
  | 'visible'
  | 'hidden'
  | 'customView'
  | 'entireCell';

export type RNITableViewEditingEditControlMode =
  | 'none'
  | 'delete'
  | 'insert';

export type RNITableViewEditingConfig = {
  isEditing: boolean;
  defaultReorderControlMode: RNITableViewEditingReorderControlMode;
  defaultEditControlMode: RNITableViewEditingEditControlMode;
};

