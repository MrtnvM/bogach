declare var process: {
  env: {
    GCLOUD_PROJECT: string;
  };
};

export const FIREBASE_APP_NAME = 'Cash Flow';
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
