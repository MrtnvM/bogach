export const parseUnionType = <T extends string>(type: string, values: T[], defaultValue: T): T => {
  const typeString = type?.trim()?.toLowerCase();
  const indexOfType = values.findIndex(t => t == typeString);

  return indexOfType >= 0 ? values[indexOfType] : defaultValue;
};
