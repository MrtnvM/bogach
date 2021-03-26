import * as uuid from 'uuid';
import * as admin from 'firebase-admin';

export type MockDocumentSnapshotParams<T> = {
  readonly exists?: boolean;
  readonly id?: string;
  readonly data: T | undefined;
};

type DocumentData = FirebaseFirestore.DocumentData;

export class MockDocumentSnapshot<T = DocumentData> extends admin.firestore.DocumentSnapshot<T> {
  private documentId: string;

  constructor(private params: MockDocumentSnapshotParams<T>) {
    super();
    this.documentId = params?.id || uuid.v4();
  }

  get id(): string {
    return this.documentId;
  }

  get exists(): boolean {
    if (this.params.exists === false) {
      return false;
    }

    return true;
  }

  data(): T | undefined {
    return this.params.data;
  }
}
