// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// 啟動 action text
require("trix")
require("@rails/actiontext")


import "controllers";
// stimulus.js的東西

// 本檔案為進入點
// 想把這個檔案變成前端（後台）專屬進入點

import "styles/backend";
// index.js已經引入application.scss，而application.scss已經引入bulma.css
// import "styles/backend/index.js"
// 寫法上可省略index.js
// import "styles/backend"; 會把該目錄中所有檔案引入
// 引入後台專屬的樣式
import "styles/shared";
// 引入前後台共用的樣式

import "scripts/backend";
// 引入後台專屬的js
import "scripts/shared";
// 引入前後台共用的js