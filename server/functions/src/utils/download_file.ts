import * as fs from 'fs';
import * as https from 'https';
import * as http from 'http';
import { createDirectoryForFileIfNeeded } from './files';

export const downloadFile = (url: string, destination: string) => {
  return new Promise<void>((resolve, reject) => {
    createDirectoryForFileIfNeeded(destination);

    const file = fs.createWriteStream(destination);
    const pkg = url.toLowerCase().startsWith('https:') ? https : http;

    pkg.get(url, function (response) {
      response.pipe(file);
      file.on('finish', function () {
        file.close();
        resolve();
      });
    });
  });
};
