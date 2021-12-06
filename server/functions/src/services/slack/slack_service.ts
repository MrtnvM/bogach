import fetch from 'node-fetch';

export class SlackService {
  private botChannelWebhook =
    'https://hooks.slack.com/services/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';

  async sendMessageToBotChannel(message: string) {
    await fetch(this.botChannelWebhook, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text: message }),
    });
  }
}
