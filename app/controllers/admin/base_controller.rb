class Admin::BaseController < ApplicationController

    # 所有後台共用的動作都寫在這
    # 這樣後台其他controller只要 繼承 這個controller就會有該有的功能

    before_action :authenticate_user!
    # devise的方法
    # 檢查當前使用者有無登入，沒登入的話，「會直接把使用者踢到登入頁面」

    layout 'backend'
    # Rails會去找與類別同名（Products）的layout，找不到的話會往上（Application）找，所以才會預設找到application.html.erb當公版
    # 這邊把 application.html.erb 作為前台專用公版，所以後台這裡要特別設定 layout公版 要去找 backend.html.erb檔案
    # 本 controller整個都套用 backend.html.erb作為layout

    include Pagy::Backend
    # 引入 分頁模組的Backend類別


end