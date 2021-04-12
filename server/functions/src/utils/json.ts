import * as fs from 'fs';

export const writeJson = (path: string, data: any) => {
  const directories = path.split('/').slice(0, -1);

  for (let i = 0; i < directories.length; i++) {
    const dirPath = directories.slice(0, i + 1).join('/');

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
