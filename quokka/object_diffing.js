import _ from "lodash";
import * as fs from "fs";

const getGame = (filename) => {
  const gamesPath = __dirname + "/../data/games/";
  const gamePath = gamesPath + filename;
  return JSON.parse(fs.readFileSync(gamePath, "utf-8"));
};

const game1 = getGame("Game 2.json");
const game2 = getGame("Game 3.json");

const getObjectKeyValueMap = (obj) => {
  const rKeys = (o, path = "") => {
    if (!o || typeof o !== "object") {
      return { path, value: o };
    }

    const key = _.chain(path).last().value();
    const isArrayItem = !Number.isNaN(parseInt(key, 10));

    if (isArrayItem) {
      return { path, value: o };
    }

    return Object.keys(o).map((key) =>
      rKeys(o[key], path ? [path, key].join("/") : key)
    );
  };

  const flattenResult = _.flattenDeep(rKeys(obj));
  const result = flattenResult.reduce((acc, curr) => {
    acc[curr.path] = curr.value;
    return acc;
  }, {});

  return result;
};

const getObjectDiff = (newObj, oldObj) => {
  const flattenNewObj = getObjectKeyValueMap(newObj);
  const flattenOldObj = getObjectKeyValueMap(oldObj);

  const diff = {};

  for (const key in flattenNewObj) {
    const newValue = flattenNewObj[key];
    const oldValue = flattenOldObj[key];

    if (oldValue === undefined) {
      diff[key] = newValue;
      continue;
    }

    if (!_.isEqual(newValue, oldValue)) {
      diff[key] = newValue;
    }
  }

  for (const key in flattenOldObj) {
    const newValue = flattenNewObj[key];

    if (newValue === undefined) {
      diff[key] = null;
    }
  }

  return diff;
};

const diff = getObjectDiff(game2, game1);
console.log("DIFF: \n", diff);

console.log(Number.isNaN(parseInt("", 10)));
