import { RequestError } from './request_error';

export class MissingJsonBodyFieldError extends RequestError {
  constructor(missingFieldName: string) {
    super(
      'Missing Json Body Field Error',
      `The field '${missingFieldName}' is not found in the json body`
    );
  }
}
