import fetch from 'node-fetch';
import { GameEntity } from '../../models/domain/game/game';

declare var process: {
  env: {
    GCLOUD_PROJECT: string;
  };
};

export const scheduleMonthEndTimer = (params: {
  startDateInUTC: string;
  gameId: GameEntity.Id;
  monthNumber: number;
}) => {
  const projectId = process.env.GCLOUD_PROJECT;
  const callbackBaseUrl = {
    'cash-flow-staging': 'https://europe-west2-cash-flow-staging.cloudfunctions.net',
    'cash-flow-uat': 'https://europe-west2-cash-flow-uat.cloudfunctions.net',
    'bogach-production': 'https://europe-west2-bogach-production.cloudfunctions.net',
  }[projectId];

  const callbackPath = '/completeMonth';
  const callbackUrl = callbackBaseUrl + callbackPath;

  const apiEndpoint = 'https://bogach-multiplayer-timer.herokuapp.com/schedule_timer';

  const body = {
    start_date: params.startDateInUTC,
    game_id: params.gameId,
    month_number: params.monthNumber,
    callback_url: callbackUrl,
  };

  const race = Promise.race([
    fetch(apiEndpoint, {
      method: 'POST',
      body: JSON.stringify(body),
      headers: {
        'Content-Type': 'application/json',
      },
    }),
    new Promise((resolve, reject) => {
      setTimeout(() => reject('Timed out'), 500);
    }),
  ]);

  return race
    .then((data) => {
      console.log(data);
    })
    .catch((e) => {
      console.error(e);
    });
};
