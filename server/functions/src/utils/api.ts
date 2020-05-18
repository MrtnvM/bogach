import * as functions from 'firebase-functions';
import { MissingQueryParamError } from '../core/exceptions/missing_query_param_error';
import { MissingJsonBodyFieldError } from '../core/exceptions/missing_json_body_field_error';

export function queryParams(request: functions.https.Request) {
  return (name: string) => {
    const value = request.query[name];

    if (!value) {
      throw new MissingQueryParamError(name);
    }

    return value;
  };
}

export function jsonBodyField(request: functions.https.Request) {
  return (path: string) => {
    const value = request.body[path];

    if (!value) {
      throw new MissingJsonBodyFieldError(path);
    }

    return value;
  };
}

export function optionalJsonBodyField(request: functions.https.Request) {
  return (path: string) => {
    const value = request.body[path];

    return value;
  };
}
