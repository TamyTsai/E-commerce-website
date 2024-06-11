// assets 目錄下的檔案 import 方式，以 app/asset/javascripts/application.js 這支檔案為例，這是一支 manifest 檔案，主要用來告訴 Sprockets 說哪些檔案是要被載入最後要被包起來壓縮的，最後這支檔案裡面所有的東西就會被包成 application.js 這支檔案，也是我們 layout/application.html.erb 中的 javascript_include_tag 'application' 中的檔案


//= require_directory .
// 你可以建立一個新的資料夾來放你不想要被 application.js 載入的檔案，例如我們在 app/assets/javascript 下建立一個 admin 資料夾把剛剛的 admin_functions.js 檔案放進去，然後把原先 application.js 中的 require_tree . 改為 require_directory . 這樣子只會抓與 apllication.js 檔案同目錄底下的所有檔案而不會去載入子目錄中的檔案。

// 啟動 action text
//= require trix
//= require @rails/actiontext