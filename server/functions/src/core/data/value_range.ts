import * as random from 'random';

export type ValueRange = {
  readonly min: number;
  readonly max: number;
  readonly stepValue: number;
};

export const singleValueRange = (value: number): ValueRange => ({
  min: value,
  max: value,
  stepValue: 0,
});

export const valueRange = (value: number | [number, number, number]): ValueRange => {
  if (typeof value === 'number') {
    return valueRange([value, value, 0]);
  }

  return {
    min: value[0],
    max: value[1],
    stepValue: value[2],
  };
};

export const optionalValueRange = (
  value?: number | [number, number, number]
): ValueRange | undefined => {
  if (typeof value === 'number') {
    return valueRange(value);
  }

  return value && valueRange(value);
};

export const randomValueFromRange = (range: ValueRange) => {
  if (range.min > range.max) {
    throw new Error('ERROR: Incorrect range ' + JSON.stringify(range));
  }

  if (range.stepValue < 0) {
    throw new Error('ERROR: Step value should be greater or equal 0 ' + JSON.stringify(range));
  }

  if (range.stepValue === 0) {
    const possibleValues = [range.min, range.max];
    return possibleValues[random.int(0, possibleValues.length - 1)];
  }

  const interval = range.max - range.min;
  const stepsCount = parseInt((interval / range.stepValue).toString());
  const randomNumber = range.min + range.stepValue * random.int(0, stepsCount);

  return randomNumber;
};
