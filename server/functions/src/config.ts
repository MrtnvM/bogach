declare var process: {
  env: {
    GCLOUD_PROJECT: string;
  };
};

import * as Rollbar from 'rollbar';

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
    } catch (err) {
      if (!ErrorRecorder.isEnabled) {
        throw err;
      }

      let errorMessage = (err && err['message']) || err;

      if (typeof errorMessage === 'object') {
        errorMessage = JSON.stringify(errorMessage);
      }

      const errorInfo =
        `${this.component.toUpperCase()}\n` +
        `ENVIRONMENT: ${environment}\n` +
        `ERROR MESSAGE: ${errorMessage}\n`;
      +`CONTEXT: ${JSON.stringify(context, null, 2)}`;

      const errorName = `${this.component.toUpperCase()}, ENVIRONMENT: ${environment},
         ERROR MESSAGE: ${errorMessage}, CONTEXT: ${JSON.stringify(context, null, 2)}`;

      //const error = new Error(errorInfo);

      if (environment === 'local' || err['type'] !== 'domain') {
        console.error(errorInfo);
        throw err;
      }

      rollbar.error(err, errorName);
      throw err;
    }
  }
}
