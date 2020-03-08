import { Validator } from '../validation/validator';

export namespace Entity {
  export type ParsingAction = (entity: any, data: any) => any;
  export type ValidationRule = (entity: any) => void;

  export const parse = <Key>(entity: any, data: any, key: Key, actions: [Key, ParsingAction][]) => {
    const actionIndex = (actions ?? []).findIndex(([actionKey]) => key === actionKey);

    if (actionIndex >= 0) {
      const [, action] = actions[actionIndex];
      return action(entity, data);
    }

    return entity;
  };

  export const validate = <Key>(entity: any, key: Key, rules: [Key, ValidationRule][]) => {
    const ruleIndex = (rules ?? []).findIndex(([ruleKey]) => key === ruleKey);

    if (ruleIndex >= 0) {
      const [, rule] = rules[ruleIndex];
      rule(entity);
    }
  };

  export const createEntityValidator = <T extends object>(entity: T) => {
    return new Validator(entity);
  };
}
