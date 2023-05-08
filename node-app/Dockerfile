FROM node:18-alpine

WORKDIR /app

COPY index.js package.json package-lock.json ./
RUN npm install --omit=dev

ENTRYPOINT [ "npm", "start" ]
