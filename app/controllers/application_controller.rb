class ApplicationController < ActionController::Base
    
    # 所有action （撈資料）都可能遇到找不到（用find方法找） 導致噴ActiveRecord::RecordNotFound的情況，所以要於此始祖controller做處理
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    # 當遇到 噴ActiveRecord::RecordNotFound錯誤訊息 時，就使用 record_not_found方法
    
    private

    def record_not_found
        render file: "#{Rails.root}/public/404.html", # 用此檔案渲染頁面 Rails.root為專案根目錄
               layout: false, # layout設定為沒有，不套用公版
               status: 404

    end
end
