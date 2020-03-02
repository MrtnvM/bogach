import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");

export const helloWorld = functions
  .region(config.CLOUD_FUNCTIONS_REGION)
  .https.onRequest((request, response) => {
    response.send('Hello from Cash Flow!');
  });
