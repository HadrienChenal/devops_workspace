FROM node:21.7
WORKDIR /home/node/app
COPY package.json .
RUN npm install
COPY app.js .
EXPOSE 8080
USER node
CMD ["npm", "start"]
