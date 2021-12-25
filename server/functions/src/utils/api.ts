import * as express from 'express';
import * as functions from 'firebase-functions';
import { MissingQueryParamError } from '../core/exceptions/api/missing_query_param_error';
import { MissingJsonBodyFieldError } from '../core/exceptions/api/missing_json_body_field_error';

export function queryParams(
  request: functions.https.Request | express.Request
): (s: string) => any {
  return (name: string) => {
    const value = request.query[name];

    if (value === undefined) {
      throw new MissingQueryParamError(name);
    }

    return value;
  };
}

export function jsonBodyField(request: functions.https.Request | express.Request) {
  return (path: string) => {
    const value = request.body[path];

    if (value === undefined) {
      throw new MissingJsonBodyFieldError(path);
    }

    return value;
  };
}

export function optionalJsonBodyField(request: functions.https.Request | express.Request) {
  return (path: string) => {
    const value = request.body[path];

    return value;
  };
}
