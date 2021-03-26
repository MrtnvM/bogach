export const parseUnionType = <T extends string>(type: string, values: T[], defaultValue: T): T => {
  const typeString = type?.trim()?.toLowerCase();
  const indexOfType = values.findIndex((t) => t === typeString);

  return indexOfType >= 0 ? values[indexOfType] : defaultValue;
};

export const doIf = <Key>(key: Key, variants: [Key, () => void][]) => {
  for (let i = 0; i < variants?.length ?? 0; i++) {
    const [variantKey, action] = variants[i];

    if (variantKey === key) {
      action();
      return;
    }
  }
};

export const getIf = <Key, Result = any>(key: Key, variants: [Key, () => Result][]) => {
  for (let i = 0; i < variants?.length ?? 0; i++) {
    const [variantKey, action] = variants[i];

    if (variantKey === key) {
      return action();
    }
  }

  return undefined;
};
