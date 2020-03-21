export class Validator<T extends object> {
  constructor(private entity: T) {
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

  hasNullableValue(field: keyof T) {
    const value = this.entity[field];

    if (value === undefined) {
      this.throwError(`The entity does not have nullable value for '${field}' field`);
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

  private throwError(reason: string) {
    throw `[VALIDATION ERROR]: ${reason}`;
  }
}
