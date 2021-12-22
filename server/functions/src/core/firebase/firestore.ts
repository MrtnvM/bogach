import { nowInUtc } from '../../utils/datetime';
import { DocumentReference, CollectionReference, Query } from '../../providers/firestore_selector';

export interface FirestoreWriteOptions {
  createdAt?: boolean;
  updatedAt?: boolean;
}

export class Firestore {
  async getItems<T = FirebaseFirestore.DocumentData>(selector: CollectionReference): Promise<T[]> {
    try {
      const items = await selector.listDocuments().then((snapshots) => {
        const dataObjects = snapshots
          .map(async (s) => (await s.get()).data())
          .filter((s) => s !== undefined)
          .map((s) => s as FirebaseFirestore.DocumentData);

        return Promise.all(dataObjects);
      });

      return items as T[];
    } catch {
      return [];
    }
  }

  getItem(selector: DocumentReference) {
    return selector.get();
  }

  getItemData<T = FirebaseFirestore.DocumentData>(
    selector: DocumentReference
  ): Promise<T | undefined> {
    return selector.get().then((snapshot) => snapshot.data() as T);
  }

  async getQueryItems(selector: Query) {
    try {
      const items = await selector.get().then((querySnapshot) => {
        const dataObjects = querySnapshot.docs //
          .map((d) => d.data())
          .filter((d) => d !== undefined);

        return Promise.all(dataObjects);
      });

      return items;
    } catch {
      return [];
    }
  }

  async createItem(selector: DocumentReference, item: any, options?: FirestoreWriteOptions) {
    const newItem = item && {
      ...item,
      ...(options?.createdAt !== false ? { createdAt: nowInUtc() } : {}),
      ...(options?.updatedAt !== false ? { updatedAt: nowInUtc() } : {}),
    };

    await selector.set(newItem);
    return newItem;
  }

  async addItem(selector: CollectionReference, item: any, options?: FirestoreWriteOptions) {
    const newItem = item && {
      ...item,
      ...(options?.createdAt !== false ? { createdAt: nowInUtc() } : {}),
      ...(options?.updatedAt !== false ? { updatedAt: nowInUtc() } : {}),
    };

    await selector.add(newItem);
    return newItem;
  }

  async updateItem(selector: DocumentReference, item: any, options?: FirestoreWriteOptions) {
    const updatedItem = item && {
      ...item,
      ...(options?.updatedAt !== false ? { updatedAt: nowInUtc() } : {}),
    };

    await selector.update(updatedItem);
    return updatedItem;
  }

  async removeItem(selector: DocumentReference) {
    return selector.delete();
  }

  async removeItems(selector: CollectionReference) {
    const items = await selector.listDocuments();
    return Promise.all(items.map((i) => i.delete()));
  }
}
