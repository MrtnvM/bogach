/// <reference types="@types/jest"/>

import { ValueRange, randomValueFromRange } from './value_range';

describe('Value range', () => {
  test('Check number generation', () => {
    const intRange: ValueRange = {
      min: 1,
      max: 10,
      stepValue: 2,
    };

    for (let i = 0; i < 100; i++) {
      const randomNumber = randomValueFromRange(intRange);

      expect(randomNumber).toBeGreaterThanOrEqual(1);
      expect(randomNumber).toBeLessThanOrEqual(10);
      expect((randomNumber - intRange.min) % 2).toEqual(0);
    }

    const floatRange: ValueRange = {
      min: -1,
      max: 10,
      stepValue: 0.2,
    };

    for (let i = 0; i < 100; i++) {
      const randomNumber = randomValueFromRange(floatRange);

      expect(randomNumber).toBeGreaterThanOrEqual(-1);
      expect(randomNumber).toBeLessThanOrEqual(10);
    }

    const incorrectRange1: ValueRange = {
      min: 0,
      max: -1,
      stepValue: 1,
    };
    expect(() => randomValueFromRange(incorrectRange1)).toThrowError();

    const incorrectRange2: ValueRange = {
      min: 0,
      max: 10,
      stepValue: 0,
    };
    expect(() => randomValueFromRange(incorrectRange2)).not.toThrowError();

    const incorrectRange3: ValueRange = {
      min: 0,
      max: 10,
      stepValue: -1,
    };
    expect(() => randomValueFromRange(incorrectRange3)).toThrowError();
  });
});
