import * as fs from 'fs';

export const createDirectoryForFileIfNeeded = (path: string) => {
  const directories = path.split('/').slice(0, -1);

  for (let i = 0; i < directories.length; i++) {
    const dirPath = directories.slice(0, i + 1).join('/');

    if (dirPath === '') {
      continue;
    }

    if (!fs.existsSync(dirPath)) {
      fs.mkdirSync(dirPath);
    }
  }
};
