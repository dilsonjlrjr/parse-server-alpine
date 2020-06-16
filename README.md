<p align="center">
    <img alt="Parse Server" src="https://github.com/parse-community/parse-server/raw/master/.github/parse-server-logo.png" width="500">
  </a>
</p>

<p align="center">
  Parse Server is an open source backend that can be deployed to any infrastructure that can run Node.js.
</p>

<p align="center">
    <a href="https://twitter.com/intent/follow?screen_name=parseplatform"><img alt="Follow on Twitter" src="https://img.shields.io/twitter/follow/parseplatform?style=social&label=Follow"></a>
  <a href="https://travis-ci.org/parse-community/parse-server"><img alt="Build status" src="https://img.shields.io/travis/parse-community/parse-server/master.svg?style=flat"></a>
    <a href="https://codecov.io/github/parse-community/parse-server?branch=master"><img alt="Coverage status" src="https://img.shields.io/codecov/c/github/parse-community/parse-server/master.svg"></a>
    <a href="https://www.npmjs.com/package/parse-server"><img alt="npm version" src="https://img.shields.io/npm/v/parse-server.svg?style=flat"></a>
    <a href="https://community.parseplatform.org/"><img alt="Join the conversation" src="https://img.shields.io/discourse/https/community.parseplatform.org/topics.svg"></a>
    <a href="https://greenkeeper.io/"><img alt="Greenkeeper badge" src="https://badges.greenkeeper.io/parse-community/parse-server.svg"></a>
</p>

<p align="center">
    <img alt="MongoDB 3.6" src="https://img.shields.io/badge/mongodb-3.6-green.svg?logo=mongodb&style=flat">
    <img alt="MongoDB 4.0" src="https://img.shields.io/badge/mongodb-4.0-green.svg?logo=mongodb&style=flat">
</p>

<h2 align="center">Our Sponsors</h2>
<p align="center">
    <p align="center">Our backers and sponsors help to ensure the quality and timely development of the Parse Platform.</p>
  <details align="center">
  <summary align="center"><b>🥉 Bronze Sponsors</b></summary>
  <a href="https://opencollective.com/parse-server/sponsor/0/website" target="_blank"><img src="https://opencollective.com/parse-server/sponsor/0/avatar.svg"></a>
  </details>

</p>
<p align="center">
  <a href="#backers"><img alt="Backers on Open Collective" src="https://opencollective.com/parse-server/backers/badge.svg" /></a>
  <a href="#sponsors"><img alt="Sponsors on Open Collective" src="https://opencollective.com/parse-server/sponsors/badge.svg" /></a>
</p>
<br>

Parse Server works with the Express web application framework. It can be added to existing web applications, or run by itself.

<hr>

- [Documentação oficial](#documentação-oficial)
- [Container Parse Alpine](#container-parse-alpine)
  - [Estrutura interna](#estrutura-interna)  
  - [Exemplo de configuração do server.js](#exemplo-de-configuração-do-server.js)
  - [Exemplo de configuração do main.js](#exemplo-de-configuração-do-main.js)
  - [Variáveis de ambiente](#variáveis-de-ambiente)
- [Docker Compose](#docker-compose)

# Documentação oficial

A documentação da plataforma Parse pode ser vista clicando [aqui](https://docs.parseplatform.org/)

- Parse Server: [https://docs.parseplatform.org/parse-server/guide/](https://docs.parseplatform.org/parse-server/guide/)
- Parse GraphQL API: [https://docs.parseplatform.org/graphql/guide/](https://docs.parseplatform.org/graphql/guide/)
- Parse iOS: [https://docs.parseplatform.org/ios/guide/](https://docs.parseplatform.org/ios/guide/)
- Parse Android: [https://docs.parseplatform.org/android/guide/](https://docs.parseplatform.org/android/guide/)
- Parse Javascript: [https://docs.parseplatform.org/js/guide/](https://docs.parseplatform.org/js/guide/)
- Parse .NET + Xamarin: [https://docs.parseplatform.org/dotnet/guide/](https://docs.parseplatform.org/dotnet/guide/)
- Parse macOS: [https://docs.parseplatform.org/macos/guide/](https://docs.parseplatform.org/macos/guide/)
- Parse Unity: [https://docs.parseplatform.org/unity/guide/](https://docs.parseplatform.org/unity/guide/)
- Parse PHP: [https://docs.parseplatform.org/php/guide/](https://docs.parseplatform.org/php/guide/)
- Parse Arduino: [https://docs.parseplatform.org/arduino/guide/](https://docs.parseplatform.org/arduino/guide/)
- Parse Embedded C: [https://docs.parseplatform.org/embedded_c/guide/](https://docs.parseplatform.org/embedded_c/guide/)
- Parse Cloud Code: [https://docs.parseplatform.org/cloudcode/guide/](https://docs.parseplatform.org/cloudcode/guide/)
- Parse REST API: [https://docs.parseplatform.org/rest/guide/](https://docs.parseplatform.org/rest/guide/)

# Container Parse Alpine

A imagem deste container cria uma instancia do servidor Parse. A estrutura do container é flexível o que torna a sua criação preparada para o público alvo iniciante ao avançado.

## Estrutura interna

Internamente no seu diretório raiz o container possui um diretório chamado *parse-server*, nele estão contidas todas as configurações necessárias para a inicialização do serviço.

A estrutura deste diretório está organizada conforme descrito a seguir:

- cloud (diretório): Configuração do Cloud Code;
- cloud/main.js: A arquivo main.js contém as Cloud Functions e que são repassadas para o Parse Server. Para mais informação acesse o [link](https://docs.parseplatform.org/cloudcode/guide/).
- server.js: Arquivo de inicialização da instância do Parse Server, escrito em node.js com uso do framework Express.

## Exemplo de configuração do server.js

```js
// Example express application adding the parse-server module to expose Parse
// compatible API routes.

var express = require("express");
var ParseServer = require("parse-server").ParseServer;
var path = require("path");

var api = new ParseServer({
  databaseURI:
    process.env.PARSE_DATABASE_URI || "mongodb://localhost:27017/dev",
  cloud: process.env.PARSE_CLOUD_CODE_MAIN || __dirname + "/cloud/main.js",
  appId: process.env.PARSE_APP_ID || "myAppId",
  masterKey: process.env.PARSE_MASTER_KEY || "", //Add your master key here. Keep it secret!
  serverURL: process.env.PARSE_URL || "http://localhost:1337/parse", // Don't forget to change to https if needed
  liveQuery: {
    classNames: ["Posts", "Comments"], // List of classes to support for query subscriptions
  },
});
// Client-keys like the javascript key or the .NET key are not necessary with parse-server
// If you wish you require them, you can set them as options in the initialization above:
// javascriptKey, restAPIKey, dotNetKey, clientKey

var app = express();

// Serve static assets from the /public folder
app.use("/public", express.static(path.join(__dirname, "/public")));

// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || "/parse";
app.use(mountPath, api);

// Parse Server plays nicely with the rest of your web routes
app.get("/", function (req, res) {
  res.status(200).send("Starting parse-server platform");
});

// There will be a test page available on the /test path of your server url
// Remove this before launching your app
app.get("/test", function (req, res) {
  res.sendFile(path.join(__dirname, "/public/test.html"));
});

var port = process.env.PARSE_PORT_NUMBER || 1337;
var httpServer = require("http").createServer(app);

httpServer.listen(port, function () {
  console.log("parse-server-example running on port " + port + ".");
});

// This will enable the Live Query real-time server
ParseServer.createLiveQueryServer(httpServer);

```
## Exemplo de configuração do main.js

```js
Parse.Cloud.define("hello", function (req, res) {
  return "Hi";
});

```

## Variáveis de Ambiente

# Docker Compose
