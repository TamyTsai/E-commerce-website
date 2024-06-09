// assets 目錄下的檔案 import 方式，以 app/asset/javascripts/application.js 這支檔案為例，這是一支 manifest 檔案，主要用來告訴 Sprockets 說哪些檔案是要被載入最後要被包起來壓縮的，最後這支檔案裡面所有的東西就會被包成 application.js 這支檔案，也是我們 layout/application.html.erb 中的 javascript_include_tag 'application' 中的檔案

//= require jquery
//= require jquery_ujs
//= require_tree ./backend
//= require_tree ./frontend

// https://gogojimmy.net/2012/07/03/understand-assets-pipline/
// 再來是 assets 目錄下的檔案 import 方式，以 app/asset/javascripts/application.js 這支檔案為例，這是一支 manifest 檔案，主要用來告訴 Sprockets 說哪些檔案是要被載入最後要被包起來壓縮的，最後這支檔案裡面所有的東西就會被包成 application.js 這支檔案，也是我們 layout/application.html.erb 中的 javascript_include_tag 'application' 中的檔案，打開這支檔案除了上面的說明外只有這三行：
// 上面兩行很明顯的就是要載入 jquery 以及 jquery_ujs 這兩支檔案，這兩支檔案剛剛有提到他其實是被包含在我們所使用的 Gem 中，
// 而下面那行 require_tree . 表示是把三個 assets/javascript 目錄下的檔案或是子目錄內的檔案全部都包進來，這時候你一定會想問如果有些 js 或是 css 我只想在某些特定頁面中使用的話該怎麼辦，例如說假設我們今天有個 admin_functions.js 的檔案「只想在我們的後台」使用，有兩種方法可以使用：
// 你可以將 require_tree 的目錄改成其他目錄，例如在 app/assets/javascript 目錄下建個 common 資料夾，把 require_tree . 改成 require_tree ./common，這樣子所產生的 application.js 這支檔案就「不會」用到 admin_functions.js 這支檔案。
// 你可以建立一個新的資料夾來放你不想要被 application.js 載入的檔案，例如我們在 app/assets/javascript 下建立一個 admin 資料夾把剛剛的 admin_functions.js 檔案放進去，然後把原先 application.js 中的 require_tree . 改為 require_directory . 這樣子只會抓 與 apllication.js 檔案同目錄底下 的 所有檔案 而 不會去載入 子目錄中的檔案。

// 除了 require_tree 及 require_directory 之外，還有其他的用法，你都可以使用絕對或是相對路徑來指定檔案位置，副檔名可有可無：
// require [路徑] 載入某支特定檔案，如果這支檔案被載入多次，Sprockets 也會很聰明的 只幫你載入一次。
// include [路徑] 與 require 一樣，差別在 即使是 被載入過的檔案 也會再被載入。
// require_directory [路徑] 將路徑下「不包含 子目錄的檔案 按照字母順序 依次載入」。
// require_tree [路徑] 會將路徑下「包含 子目錄的檔案」全部載入。
// require_self [路徑] 告訴 Sprockets 再載入其他的檔案前，「先將自己的內容插入」。
// depend_on [路徑] 宣告依賴於某支 js，在需要通知某支快取的 assets 過期時非常實用。
// stub [路徑] 將路徑中的 assets 加入黑名單，所有其他的 require 都不會將他載入。