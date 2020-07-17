FROM node:alpine

EXPOSE 1337
EXPOSE 3000

RUN mkdir -p /parse-server/cloud
RUN mkdir -p /parse-server/public

COPY ./parse-server/server.js /parse-server/server.js
COPY ./parse-server/cloud/main.js /parse-server/cloud/main.js
COPY ./parse-server/public/test.html /parse-server/public/test.html
COPY ./parse-server/package.json /parse-server/package.json

WORKDIR /parse-server

RUN npm i -g pm2
RUN npm install

ENV PARSE_URL=http://localhost:1337/parse
ENV PARSE_MOUNT="/parse"
ENV PARSE_PORT_NUMBER=1337
ENV PARSE_APP_ID=myappID
ENV PARSE_MASTER_KEY=mymasterKey
ENV PARSE_DATABASE_URI=mongodb://mongo.parse:27017/database_dev
ENV PARSE_CLOUD_CODE_MAIN=/parse-server/cloud/main.js
ENV PARSE_APP_NAME=appName
ENV PARSE_EMAIL_ADAPTER=emailAdapter
ENV PARSE_EMAIL_DOMAIN=emailDomain
ENV PARSE_EMAIL_APIKEY=emailApiKey

CMD [ "pm2-runtime", "/parse-server/server.js", "-i max" ]