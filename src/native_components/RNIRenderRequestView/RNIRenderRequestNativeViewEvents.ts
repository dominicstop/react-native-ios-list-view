import { NativeSyntheticEvent } from "react-native";


export type OnRenderRequestEventObject = NativeSyntheticEvent<{
  renderRequestKey: number;
}>;

export type OnRenderRequestEvent = (
  event: OnRenderRequestEventObject
) => void;