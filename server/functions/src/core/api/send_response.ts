import * as functions from 'firebase-functions';

export const sendResponse = <T>(data: Promise<T>, response: functions.Response) => {
  return data
    .then((result) => response.status(200).send(result))
    .catch((error) => {
      if (error['type'] === 'domain') {
        const json = JSON.stringify(error);
        response.status(422).send(json);
        return;
      }

      const errorMessage = error['message'] ? error.message : error;
      console.error('ERROR: ' + JSON.stringify(error));
      console.error('ERROR MESSAGE: ' + errorMessage);
      response.status(422).send(errorMessage);
    });
};
