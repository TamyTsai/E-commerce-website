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

import "controllers";
// stimulus.js的東西

// 把進入點（前端入口） 變成 index.js
import "styles/frontend/index.js";
// index.js已經引入application.scss，而application.scss已經引入bulma.css
// 寫法上可省略index.js
// import "styles/frontend";
