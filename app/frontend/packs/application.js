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


const images = require.context('../images', true)
const imagePath = (name) => images(name, true)
// 如此一來，在其他地方引入圖片時 就可以寫 <%= image_pack_tag 'rails.png' %>
// 就會到webpacker進入點來源資料夾 的 images 資料夾下找圖片

import "controllers";
// stimulus.js的東西

// 本檔案為進入點
// 想把這個檔案變成前端（前台）專屬進入點

import "styles/frontend";
// index.js已經引入application.scss，而application.scss已經引入bulma.css
// import "styles/frontend/index.js"
// 寫法上可省略index.js
// import "styles/frontend"; 會把該目錄中所有檔案引入
// 引入前台專屬的樣式
import "styles/shared";
// 引入前後台共用的樣式

import "scripts/frontend";
// 引入前台專屬的js
import "scripts/shared";
// 引入前後台共用的js
