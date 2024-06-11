# $ rails g controller admin/products
#       create  app/controllers/admin/products_controller.rb
#       invoke  erb
#       create    app/views/admin/products
#       invoke  rspec
#       create    spec/requests/admin/products_spec.rb

# 會做出products controller，但是是放在admin資料夾，且 類別 前面 自動加上 namespace模組名稱

class Admin::ProductsController < Admin::BaseController

    def index # 後台商品列表頁面 對應的action
    end

    def new
        @product = Product.new
    end
    
end
