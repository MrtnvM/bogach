import fetch from 'node-fetch';
import { getCurrentEnvironment } from '../../config';

export class SlackProvider {
  private botChannelWebhook =
    'https://hooks.slack.com/services/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';

  async sendMessageToBotChannel(message: string) {
    const env = `*[${getCurrentEnvironment().toUpperCase()}]* `;
    await fetch(this.botChannelWebhook, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        text: env + message,
      }),
    });
  }
}
