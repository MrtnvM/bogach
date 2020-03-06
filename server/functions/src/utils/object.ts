export function removeKeys(obj: { [field: string]: any }, keys: string[]) {
  for (const prop in obj) {
    if (!obj.hasOwnProperty(prop)) {
      continue;
    }

    switch (typeof obj[prop]) {
      case 'string':
        if (keys.indexOf(prop) > -1) {
          delete obj[prop];
        }
        break;

      case 'object':
        if (keys.indexOf(prop) > -1) {
          delete obj[prop];
        } else {
          removeKeys(obj[prop], keys);
        }
        break;
    }
  }
}
