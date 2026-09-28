FROM node:22-bookworm-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_OPTIONS=--openssl-legacy-provider

CMD ["npm", "start"]