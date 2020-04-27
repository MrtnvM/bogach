export const assertExists = (description: string, value: any) => {
  if (value === undefined || value === null) {
    throw new Error(`ERROR: ${description} can not be undefinded or null`);
  }
};
