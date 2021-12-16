import * as fs from 'fs';
import * as crypto from 'crypto';

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

export const getFileHash = async (path: string) => {
  const fileBuffer = await fs.promises.readFile(path);
  const hashSum = crypto.createHash('sha256');
  hashSum.update(fileBuffer);

  const hex = hashSum.digest('hex');
  return hex;
};
