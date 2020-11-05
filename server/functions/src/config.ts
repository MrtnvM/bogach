declare var process: {
  env: {
    GCLOUD_PROJECT: string;
  };
};

export const CLOUD_FUNCTIONS_REGION = 'europe-west2';

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
