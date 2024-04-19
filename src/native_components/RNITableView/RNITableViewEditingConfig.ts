
export type RNITableViewEditingReorderControlMode  =
  | 'visible'
  | 'hidden'
  | 'invisible'
  | 'center'
  | 'entireCell'
  | 'customView';

export type RNITableViewEditingEditControlMode =
  | 'none'
  | 'delete'
  | 'insert';

export type RNITableViewEditingConfig = {
  isEditing: boolean;
  defaultReorderControlMode: RNITableViewEditingReorderControlMode;
  defaultEditControlMode: RNITableViewEditingEditControlMode;
};

