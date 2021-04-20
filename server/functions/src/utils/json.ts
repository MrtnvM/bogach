import * as fs from 'fs';

export const writeJson = (path: string, data: any) => {
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
