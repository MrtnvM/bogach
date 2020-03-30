export const assertExists = (description: string, value: any) => {
  if (value == undefined || value == null) {
    throw `ERROR: ${description} can not be undefinded or null`;
  }
};
