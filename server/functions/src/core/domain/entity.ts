import { Validator } from '../validation/validator';

export namespace Entity {
  export const createEntityValidator = <T extends object>(entity: T) => {
    return new Validator(entity);
  };
}
