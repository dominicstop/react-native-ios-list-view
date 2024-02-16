import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ReactNativeIosCollectionView.web.ts
// and on native platforms to ReactNativeIosCollectionView.ts
import ReactNativeIosCollectionViewModule from './ReactNativeIosCollectionViewModule';
import ReactNativeIosCollectionView from './ReactNativeIosCollectionView';
import { ChangeEventPayload, ReactNativeIosCollectionViewProps } from './ReactNativeIosCollectionView.types';

// Get the native constant value.
export const PI = ReactNativeIosCollectionViewModule.PI;

export function hello(): string {
  return ReactNativeIosCollectionViewModule.hello();
}

export async function setValueAsync(value: string) {
  return await ReactNativeIosCollectionViewModule.setValueAsync(value);
}

const emitter = new EventEmitter(ReactNativeIosCollectionViewModule ?? NativeModulesProxy.ReactNativeIosCollectionView);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ReactNativeIosCollectionView, ReactNativeIosCollectionViewProps, ChangeEventPayload };
