import * as fs from 'fs';
import { createDirectoryForFileIfNeeded } from './files';

export const writeJson = (path: string, data: any) => {
  createDirectoryForFileIfNeeded(path);

  if (fs.existsSync(path)) {
    fs.unlinkSync(path);
  }

  const jsonData = JSON.stringify(data, null, 2);
  fs.writeFileSync(path, jsonData);
};

export const readJsonFile = (path: string): Promise<any> => {
  return new Promise((resolve, reject) => {
    fs.readFile(path, (err, content) => {
      if (err) {
        console.log('Error loading JSON file:', err);
        reject(err);
        return;
      }

      const json = JSON.parse(content as any);
      resolve(json);
    });
  });
};

export const readJsonFileSync = (path: string): any => {
  const content = fs.readFileSync(path);
  const data = JSON.parse(content as any);
  return data;
};
