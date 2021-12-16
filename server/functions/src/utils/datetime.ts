import * as admin from 'firebase-admin';

export function nowInUtc(): number {
  const date = new Date();
  const utc = Date.UTC(
    date.getUTCFullYear(),
    date.getUTCMonth(),
    date.getUTCDate(),
    date.getUTCHours(),
    date.getUTCMinutes(),
    date.getUTCSeconds()
  );

  return new Date(utc).getTime();
}

export const dateFromTimestamp = (timestamp: any) => {
  return (timestamp as admin.firestore.Timestamp).toDate();
};
