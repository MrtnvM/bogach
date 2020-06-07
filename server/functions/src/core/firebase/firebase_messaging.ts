import * as admin from 'firebase-admin';

export type PushNotification = {
  title?: string;
  body?: string;
  data?: any;
  pushTokens?: string[];
};

export class FirebaseMessaging {
  async sendMulticastNotification(notification: PushNotification) {
    admin
      .messaging()
      .sendMulticast({
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: notification.data,
        tokens: notification.pushTokens || [],
      })
      .then((response) => {
        const failedTokens: (string | undefined)[] = [];

        if (response.failureCount > 0) {
          response.responses.forEach((resp, i) => {
            if (!resp.success) {
              failedTokens.push(notification.pushTokens && notification.pushTokens[i]);
            }
          });

          this.log('List of tokens that caused failures:\n' + failedTokens);
        } else {
          this.log('All push notifications sent successfully');
        }

        return { failedTokens };
      })
      .catch((error) => {
        this.log('ERROR: on sending multicast message: ' + JSON.stringify(error));
        throw error;
      });
  }

  private log(message: string) {
    console.log('[FirebaseMessaging]: ' + message);
  }
}
