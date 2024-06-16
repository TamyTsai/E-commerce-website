## 簡介
- 本專案為一個電子商務網站
- 以HTML、CSS、JavaScript及Ruby撰寫，為動態網頁
- 設計模式（design pattern）採用MVC架構
- 樣式部分以SCSS撰寫，提升程式碼可讀性
- 使用Bulma樣式及效果設計頁面，並達成RWD效果，使網頁適應各尺寸裝置瀏覽
- 圖示使用Font Awesome，以方便控制大小顏色等設定
- 使用ES6使JavaScript語法變得簡潔（箭頭函式、key與value相同之簡寫等）
- 採用UJS寫法，維持HTML簡潔
- 運用AJAX技術，提升使用者體驗
- 使用Stimulus框架
- 串接第三方登入（google）
- 使用Turbolinks讓網頁切換更快速
- 使用Rails框架製作網頁
- 使用Action Text製作文字編輯器
- 運用Nest form巢狀表單寫法（Action View）
- 使用Faraday套件串接API
- 使用Active Storage處理圖檔上傳功能，並使用image processing處理上傳後之圖檔
- 使用devise套件製作會員系統功能，並客製化
- 使用aasm有限狀態機操控訂單狀態
- 使用friendly id套件，美化網址顯示，並達避免洩漏過多資訊之效果
- 使用paranoia套件，達到軟刪除效果
- 使用figaro套件，設定全域環境變數，並避免內含機敏資訊之檔案被git追蹤
- 使用pagy套件，製作分頁功能
- 使用acts as list與SortableJS套件，製作後台系統商品分類拖拉功能
- 串接Line Pay金流服務
- 採TDD測試驅動開發，遵循3A原則（Arrange、Act、Assert），並採工廠設計模式（factory design pattern）
  - 使用RSpec進行測試
  - 使用Factory Bot及faker套件產生測試用資料
  - 使用DatabaseCleaner套件，確保在測試期間資料庫已先被清理過
- 使用PostgreSQL資料庫儲存資料

## 功能
- 會員系統功能
  - 註冊、登入、登出
  - 允許使用第三方平台（google）註冊、登入
  - 編輯個人資料、修改密碼
- 前台功能
  - 商品列表
  - 商品分類
  - 商品下單（可選規格及數量）
  - 訂單記錄
  - 購物車
  - 使用LinePay付款功能
  - 電子報訂閱
- 後台功能
  - 廠商管理
    - CRUD
  - 商品管理
    - CRUD
    - 商品主圖上傳功能
    - 增加商品規格功能
    - 商品描述文章編輯器（字型、顏色、粗體...）功能
  - 商品分類管理
    - CRUD
    - 商品分類拖拉排序功能
- 刪除功能皆採軟刪除
- 商品、廠商建立或修改...等，皆會於頁面上方跳出一次性系統訊息

<!-- ## 畫面
### 瀏覽器畫面


### 行動裝置畫面 -->



## 安裝
以下皆為於macOS環境運行
### 安裝Ruby
```bash
$ brew install ruby
```
### 安裝Rails v6.1.7.7
```bash
$ gem install rails -v 6.1.7.7
```
### 下載PostgreSQL
```bash
$ brew install postgresql
```
### 建立資料庫
```bash
$ rails db:create
```
### 建立資料表
```bash
$ rails db:migrate
```
### 取得專案
```bash
$ git clone https://github.com/TamyTsai/E-commerce-website.git
```
### 移動到專案內
```bash
$ cd E-commerce-website
```
### 安裝相關套件
```bash
$ bundle install
```
### 環境變數設定
請將config目錄下application.yml.sample重新命名，檔案名稱刪除「.sample」，並依照自身需求設定檔案中之環境變數

### 啟動rails伺服器
```bash
$ rails s
```
### 開啟專案
在瀏覽器網址列輸入以下網址即可看到專案首頁
```bash
http://localhost:3000/
```

## 主要資料夾及檔案說明
- app - 核心程式放置處
- bin - rails、webpack、yarn 基本指令放置處
- config- rails 的基本文件放置處
- db - 定義資料庫綱要（schema）、資料庫遷移（migration）之處
- lib - 自行定義檔案放置處（rake等）
- log - 本專案記錄檔放置處
- public - 本專案靜態檔案 (404、422、500 錯誤顯示畫面)
- spec - RSpec測試相關檔案放置處
- tmp - 臨時或暫時用文件放置處
- vender - 第三方文件放置處
- Gemfile - 要安裝 Ruby 的套件放置處
- Gemfile.lock - 當套件放置 /Gemfile 資料夾時，在終端機輸入 bundle install (可簡化為bundle)，會在此生成此套件的基本設定檔
- gitignore - 以 git 做版本控制時，不想被 git 追蹤的檔案名稱放置處
- Rakefile - 用來載入 rake 命令包含的任務

## 專案技術
- HTML
- CSS
  - SCSS
  - RWD
  - Bulma v1.0.1
  - Font Awesome v6.5.2
- JavaScripts
  - ES6
  - AJAX
  - Stimulus.js
- Ruby v2.7.8
  - Rails v6.1.7.7
    - aasm v5.5.0
    - ActiveStorage v6.1.7.7
    - ActionText v6.1.7.7
    - ActionView v6.1.7.7
    - acts as list v1.2.1
    - DatabaseCleaner v2.0.2
    - devise v4.9.4
    - factory bot rails v6.4.3
    - faker v3.4.1
    - faraday v2.8.1
    - figaro v1.2.0
    - friendly id v5.5.1
    - image processing v1.12.2
    - oauth2 v2.0.9
    - omniauth v2.1.2
    - omniauth google oauth2 v1.1.2
    - omniauth oauth2 v1.8.0
    - pagy v6.5.0
    - paranoia v2.6.3
    - RSpec rails v6.1.2
    - turbolinks v5.2.1
- PostgreSQL v1.5.6

## 第三方服務
- Google第三方登入
- LinePay金流串接
