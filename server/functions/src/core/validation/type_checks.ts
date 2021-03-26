export const checkId = (id: any) => {
  if (typeof id !== 'string' || id.length === 0) {
    throw new Error('ERROR: ID should non-empty string. Incorrect ID: ' + id);
  }
};

export const checkIds = (ids: any[]) => {
  if (!Array.isArray(ids)) {
    throw new Error('ERROR: IDs is not array');
  }

  ids.forEach(checkId);
};
