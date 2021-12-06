declare var process: {
  env: {
    GCLOUD_PROJECT: string;
  };
};

import * as Rollbar from 'rollbar';
import * as admin from 'firebase-admin';

/// Firebase

export const FIREBASE_STAGING_CONFIG = {
  databaseURL: 'https://cash-flow-staging.firebaseio.com',
  storageBucket: 'cash-flow-staging.appspot.com',
  credential: admin.credential.cert(
    require('../environments/staging/firebase_service_account.json')
  ),
};

export const FIREBASE_PRODUCTION_CONFIG = {
  databaseURL: 'https://bogach-production.firebaseio.com',
  storageBucket: 'bogach-production.appspot.com',
  credential: admin.credential.cert(
    require('../environments/production/firebase_service_account.json')
  ),
};

/// Cloud

export const CLOUD_FUNCTIONS_REGION = 'europe-west2';

/// Environment

export type APIEnvironment = 'local' | 'staging' | 'uat' | 'production';

export const getCurrentEnvironment = (): APIEnvironment => {
  const projectId = process.env.GCLOUD_PROJECT;

  switch (projectId) {
    case 'cash-flow-staging':
      return 'staging';

    case 'cash-flow-uat':
      return 'uat';

    case 'bogach-production':
      return 'production';

    default:
      return 'local';
  }
};

export const getDatabaseURL = () => {
  const env = getCurrentEnvironment();

  switch (env) {
    case 'local':
      return 'https://cash-flow-staging.firebaseio.com';

    case 'staging':
      return 'https://cash-flow-staging.firebaseio.com';

    case 'uat':
      return 'https://cash-flow-uat.firebaseio.com';

    case 'production':
      return 'https://bogach-production.firebaseio.com';
  }
};

export const getStorageBucket = () => {
  const env = getCurrentEnvironment();

  switch (env) {
    case 'local':
      return 'cash-flow-staging.appspot.com';

    case 'staging':
      return 'cash-flow-staging.appspot.com';

    case 'uat':
      return 'cash-flow-uat.appspot.com';

    case 'production':
      return 'bogach-production.appspot.com';
  }
};

export const getCredentials = () => {
  const env = getCurrentEnvironment();

  switch (env) {
    case 'local':
      return undefined;

    case 'staging':
      return require('../environments/staging/firebase_service_account.json');

    case 'uat':
      return require('../environments/uat/firebase_service_account.json');

    case 'production':
      return require('../environments/production/firebase_service_account.json');
  }
};

/// Rollbar
export const rollbar = new Rollbar({
  accessToken: '30d4dbdf62264a4cb93cda53ea80bebe',
  captureUncaught: true,
  captureUnhandledRejections: true,
  environment: getCurrentEnvironment(),
});

export class ErrorRecorder {
  static isEnabled: boolean = true;

  constructor(private component: string) {}

  async executeWithErrorRecording<T>(context: any, callback: () => Promise<T>): Promise<T> {
    const environment = getCurrentEnvironment();

    try {
      return await callback();
    } catch (error: any) {
      if (!ErrorRecorder.isEnabled) {
        throw error;
      }

      let errorMessage = (error && error['message']) || error;

      if (typeof errorMessage === 'object') {
        errorMessage = JSON.stringify(errorMessage);
      }

      const errorInfo =
        `ERROR MESSAGE: ${errorMessage}, ` +
        `COMPONENT: ${this.component.toUpperCase()}, ` +
        `ENVIRONMENT: ${environment}, ` +
        `CONTEXT: ${JSON.stringify(context, null, 2)}`;

      if (environment === 'local' || error['type'] === 'domain') {
        console.error(errorInfo);
        throw error;
      }

      rollbar.error(error, errorInfo);
      throw error;
    }
  }
}
