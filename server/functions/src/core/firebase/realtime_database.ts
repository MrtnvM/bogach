import * as admin from 'firebase-admin';
import { nowInUtc } from '../../utils/datetime';

export interface RealtimeDatabaseWriteOptions {
  createdAt?: boolean;
  updatedAt?: boolean;
}

export class RealtimeDatabase {
  async getValue(ref: admin.database.Reference): Promise<any> {
    const value = await ref.once('value');
    return value.val();
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
    options?: RealtimeDatabaseWriteOptions
  ) {
    const updatedItem = item && {
      ...item,
      ...(options?.updatedAt !== false ? { updatedAt: nowInUtc() } : {}),
    };

    await ref.update(updatedItem);
    return updatedItem;
  }

  async removeItem(ref: admin.database.Reference) {
    return ref.remove();
  }
}
