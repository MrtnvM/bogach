import { RequestError } from './request_error';

export class MissingQueryParamError extends RequestError {
  constructor(missingParamName: string) {
    super(
      'Missing Query Field Error',
      `The parameter '${missingParamName}' is not found in the query params`
    );
  }
}
