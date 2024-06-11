# $ rails g controller admin/products
#       create  app/controllers/admin/products_controller.rb
#       invoke  erb
#       create    app/views/admin/products
#       invoke  rspec
#       create    spec/requests/admin/products_spec.rb

# 會做出products controller，但是是放在admin資料夾，且 類別 前面 自動加上 namespace模組名稱

class Admin::ProductsController < Admin::BaseController

    def index # 後台 商品列表 頁面 對應的action
    end

    def new # 後台 新增商品頁面 對應的action
        @product = Product.new
    end
    
    def create # 以POST方法送出 後台 新增商品頁面 中所填入的資料 所對應的action
        # admin_products    POST     /admin/products(.:format)      admin/products#create
        @product = Product.new(product_parms)
        # 傳入清洗過後的參數，新建product物件

        if @product.save
            redirect_to admin_products_path, notice: "商品資料新增成功!"
        else
            render :new
            # 去new這個頁面，重新渲染一次（不是重新執行new方法（action）），是請view中的new頁面重畫一次
            # 本質上還是在create這個action中，並非執行new action
            # render就是要借new.html檔案來用
            # new.html檔案需要＠product 實體變數（所以才會在create action中，也寫一個跟new action中相同的 ＠product實體變數）（但也有 沒 這麼剛好（有同名實體變數）的狀況）
            # 這裡抓到的 ＠product實體變數 已經不像new action中是新創出來的，是裡頭已經有料（product_params）的 物件、model
        end
    end

    private

    def product_parms # 清洗參數
        params.require(:product).permit(:name, :vendor_id, :list_price, :sell_price)
    end

end
