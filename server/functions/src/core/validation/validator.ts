export class Validator<T extends object> {
  constructor(private entity: T, private context: any) {
    if (!entity) {
      this.throwError(`Entity can not be undefined or null`);
    }
  }

  has(field: keyof T) {
    const entityKeys = Object.keys(this.entity);

    if (typeof field !== 'string' || entityKeys.indexOf(field) < 0) {
      this.throwError(`No '${field}' field in the entity object`);
    }
  }

  hasValue(field: keyof T) {
    const value = this.entity[field];

    if (value === undefined || value === null) {
      this.throwError(`The entity does not have value for '${field}' field`);
    }
  }

  hasNumberValue(field: keyof T) {
    const value = this.entity[field];

    if (value === undefined || value === null || typeof value !== 'number') {
      this.throwError(`The entity does not have number value for '${field}' field`);
    }
  }

  hasStringValue(field: keyof T) {
    const value = this.entity[field];

    if (value === undefined || value === null || typeof value !== 'string') {
      this.throwError(`The entity does not have string value for '${field}' field`);
    }
  }

  hasObjectValue(field: keyof T, validate: (obj: any) => void) {
    const value = this.entity[field];

    if (value === undefined || value === null || typeof value !== 'object') {
      this.throwError(`The entity does not have object value for '${field}' field`);
    }

    validate(value);
  }

  hasNullableValue(field: keyof T) {
    const value = this.entity[field];

    if (value === undefined) {
      this.throwError(`The entity does not have nullable value for '${field}' field`);
    }
  }

  hasArrayValue(field: keyof T) {
    this.hasValue(field);

    const value = this.entity[field];

    if (!Array.isArray(value)) {
      this.throwError(`The entity does not have array value for '${field}' field`);
    }
  }

  hasValuesForKeys(field: keyof T, keys: string[]) {
    this.hasValue(field);

    const value = this.entity[field];
    const objectKeys = Object.keys(value).sort();
    const sortedExpectedKeys = [...keys].sort();

    if (JSON.stringify(objectKeys) !== JSON.stringify(sortedExpectedKeys)) {
      const expectedKeys = sortedExpectedKeys.join(', ');
      this.throwError(
        `The entity does not have all expected keys (${expectedKeys}) for '${field}' field`
      );
    }
  }

  check(condition: (entity: T) => string | undefined) {
    const checkResult = condition(this.entity);

    if (checkResult) {
      this.throwError(checkResult);
    }
  }

  checkWithRules(rules: [(entity: T) => boolean, string][]) {
    const failedRuleIndex = rules.findIndex(([rule]) => rule(this.entity));

    if (failedRuleIndex >= 0) {
      const errorMessage = rules[failedRuleIndex][1];
      this.throwError(errorMessage);
    }
  }

  checkUnion(field: keyof T, unionValues: any[]) {
    const value = this.entity[field];

    if (unionValues.indexOf(value) < 0) {
      const valuesList = unionValues.join(', ');
      const errorMessage = `The ${field} field can have only these values: ${valuesList}`;

      this.throwError(errorMessage);
    }
  }

  checkNullableUnion(field: keyof T, unionValues: any[]) {
    const value = this.entity[field];

    if (value === undefined) {
      this.throwError(`The entity does not have nullable value for '${field}' field`);
    }

    if (value === null) {
      return;
    }

    if (unionValues.indexOf(value) < 0) {
      const valuesList = unionValues.join(', ');
      const errorMessage = `The ${field} field can have only these values: ${valuesList}`;

      this.throwError(errorMessage);
    }
  }

  private throwError(reason: string) {
    const error = `[VALIDATION ERROR]: ${reason}`;
    const context = this.context ? `\n[CONTEXT]: ${this.context}` : '';
    const entity = `\n[ENTITY]: ${JSON.stringify(this.entity, null, 2)}`;

    throw error + context + entity;
  }
}
