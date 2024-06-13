class ApplicationController < ActionController::Base
    
    # 所有action （撈資料）都可能遇到找不到（用find方法找） 導致噴ActiveRecord::RecordNotFound的情況，所以要於此始祖controller做處理
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    # 當遇到 噴ActiveRecord::RecordNotFound錯誤訊息 時，就使用 record_not_found方法

    before_action :find_categories, unless: :backend? # 只有在不是後台時 才使用find_categories方法
    
    private

    def record_not_found
        render file: "#{Rails.root}/public/404.html", # 用此檔案渲染頁面 Rails.root為專案根目錄
               layout: false, # layout設定為沒有，不套用公版
               status: 404

    end

    def find_categories # top menu在 所有 前台頁面 都會在，所以將top menu商品分類排序的方法寫在 application層級 controller
        @categories = Category.order(position: :asc)
        # 省略.all的寫法
        # 將categories資料表內的資料 按position欄位的值 撈出來 由小到大排序 
    end

    def backend? # 但後台不會用到find_categories方法，所以再寫一個方法判斷 是否為後台
        controller_path.split('/').first == 'Admin'
        # controller_path 會抓到目前controller所在的路徑
        # 以 / 為分割符號 將路徑字串分為多個元素
        # .first抓到第一個元素
    end

end
