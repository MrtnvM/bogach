FROM --platform=linux/amd64 node:12

WORKDIR /usr/src/app

COPY yarn.lock yarn.lock
COPY package.json package.json
RUN yarn install

COPY tsconfig.json ./
COPY src ./src
COPY data ./data
COPY environments ./environments

RUN yarn build \
    && rm -rf ./src \
    && rm tsconfig.json \
    && rm -rf node_modules 

RUN yarn install --production

EXPOSE 3000

CMD [ "node", "lib/server.js" ]