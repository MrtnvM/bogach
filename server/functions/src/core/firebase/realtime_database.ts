import * as admin from 'firebase-admin';
import { nowInUtc } from '../../utils/datetime';
import * as _ from 'lodash';

const isOlderThan2Minutes = (date: Date) => {
  const now = new Date();
  const diffInSeconds = Math.abs(now.getTime() - date.getTime()) / 1000;
  return diffInSeconds > 120;
};

export interface RealtimeDatabaseWriteOptions {
  createdAt?: boolean;
  updatedAt?: boolean;
}

type ValueListener = {
  ref: admin.database.Reference;
  currentValue?: any;
  listener: (value: any) => any;
  updatedAt: Date;
};

export class RealtimeDatabase {
  private valueListeners: { [key: string]: ValueListener } = {};

  constructor() {
    setInterval(() => {
      for (const valueListenerKey in this.valueListeners) {
        const valueListener = this.valueListeners[valueListenerKey];

        if (isOlderThan2Minutes(valueListener.updatedAt)) {
          const { ref, listener } = valueListener;
          ref.off('value', listener);
          delete this.valueListeners[valueListenerKey];
        }
      }
    }, 1000);
  }

  async getValue(ref: admin.database.Reference): Promise<any> {
    return new Promise((resolve, reject) => {
      const { key } = ref;
      if (!key) throw new Error('Missing key on quering value from Realtime Database');

      const valueListener = this.valueListeners[key];
      const isValueListenerExpired = valueListener && isOlderThan2Minutes(valueListener.updatedAt);

      if (valueListener && !isValueListenerExpired) {
        if (valueListener.currentValue) {
          resolve(valueListener.currentValue);
        }

        return;
      }

      let isPromiseResolved = false;

      const newValueListener: ValueListener = {
        ref,
        currentValue: undefined,
        updatedAt: new Date(),
        listener: (value: admin.database.DataSnapshot) => {
          const listener = this.valueListeners[key];
          if (!listener) return;

          listener.updatedAt = new Date();
          listener.currentValue = value.val();

          if (!isPromiseResolved) {
            isPromiseResolved = true;
            resolve(listener.currentValue);
          }
        },
      };

      this.valueListeners[key] = newValueListener;
      ref.on('value', newValueListener.listener);
    });
  }

  async getQueryItems(ref: admin.database.Query) {
    const value = await ref.once('value');
    return value.val();
  }

  async createItem(
    ref: admin.database.Reference,
    item: any,
    options?: RealtimeDatabaseWriteOptions
  ) {
    const newItem = item && {
      ...item,
      ...(options?.createdAt !== false ? { createdAt: nowInUtc() } : {}),
      ...(options?.updatedAt !== false ? { updatedAt: nowInUtc() } : {}),
    };

    await ref.set(newItem);

    return newItem;
  }

  async addItem(ref: admin.database.Reference, item: any, options?: RealtimeDatabaseWriteOptions) {
    const newItem = item && {
      ...item,
      ...(options?.createdAt !== false ? { createdAt: nowInUtc() } : {}),
      ...(options?.updatedAt !== false ? { updatedAt: nowInUtc() } : {}),
    };

    await ref.push(newItem);
    return newItem;
  }

  async updateItem(
    ref: admin.database.Reference,
    item: any,
    oldItem?: any,
    options?: RealtimeDatabaseWriteOptions
  ) {
    const updatedItem = item && {
      ...item,
      ...(options?.updatedAt !== false ? { updatedAt: nowInUtc() } : {}),
    };

    if (oldItem) {
      const diff = this.getObjectDiff(item, oldItem);
      await ref.update(diff);
    } else {
      await ref.update(updatedItem);
    }

    return updatedItem;
  }

  async removeItem(ref: admin.database.Reference) {
    return ref.remove();
  }

  private getObjectDiff(newObj: any, oldObj: any) {
    const flattenNewObj = this.getObjectKeyValueMap(newObj);
    const flattenOldObj = this.getObjectKeyValueMap(oldObj);

    const diff = {};

    for (const key in flattenNewObj) {
      const newValue = flattenNewObj[key];
      const oldValue = flattenOldObj[key];

      if (oldValue === undefined) {
        diff[key] = newValue;
        continue;
      }

      if (!_.isEqual(newValue, oldValue)) {
        diff[key] = newValue;
      }
    }

    for (const key in flattenOldObj) {
      const newValue = flattenNewObj[key];

      if (newValue === undefined) {
        diff[key] = null;
      }
    }

    return diff;
  }

  private getObjectKeyValueMap(obj: any): Record<string, any> {
    const rKeys = (o, path = '') => {
      if (!o || typeof o !== 'object') {
        return { path, value: o };
      }

      const objectKey = _.chain(path).last().value() || '';
      const isArrayItem = !Number.isNaN(parseInt(objectKey, 10));

      if (isArrayItem) {
        return { path, value: o };
      }

      return Object.keys(o).map((key) => rKeys(o[key], path ? [path, key].join('/') : key));
    };

    const flattenResult = _.flattenDeep(rKeys(obj));
    const result = flattenResult.reduce((acc: any, curr: any) => {
      acc[curr.path] = curr.value;
      return acc;
    }, {} as any);

    return result as any;
  }
}
