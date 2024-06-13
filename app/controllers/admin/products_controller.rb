# $ rails g controller admin/products
#       create  app/controllers/admin/products_controller.rb
#       invoke  erb
#       create    app/views/admin/products
#       invoke  rspec
#       create    spec/requests/admin/products_spec.rb

# 會做出products controller，但是是放在admin資料夾，且 類別 前面 自動加上 namespace模組名稱

class Admin::ProductsController < Admin::BaseController

    before_action :find_product, only: [:edit, :update, :destroy]

    def index # 後台 商品列表 頁面 對應的action
        @products = Product.all.includes(:vendor)
        # 有N+1問題
        # 顯示列表時搜尋一次，又對N筆商品資料各收尋一次
        # .includes(:vendor)可解決N+1問題
        # 搜尋時會改用IN語法
        # 這樣只會搜尋兩次（一次搜尋整個列表，一次搜尋廠商）

        #   ↳ app/views/admin/products/index.html.erb:16
        #   Vendor Load (1.1ms)  SELECT "vendors".* FROM "vendors" WHERE "vendors"."deleted_at" IS NULL AND "vendors"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
        #   ↳ app/views/admin/products/index.html.erb:21
        #   CACHE Vendor Load (0.0ms)  SELECT "vendors".* FROM "vendors" WHERE "vendors"."deleted_at" IS NULL AND "vendors"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
        # -----
        #   ↳ app/views/admin/products/index.html.erb:16
        #   Vendor Load (0.6ms)  SELECT "vendors".* FROM "vendors" WHERE "vendors"."deleted_at" IS NULL AND "vendors"."id" = $1  [["id", 1]]

        @pagy, @products = pagy(Product.all)

    end

    def new # 後台 新增商品頁面 對應的action
        @product = Product.new
        @product.skus.build
        # build 為has_many長出來的方法，表示 放在記憶體裡 尚未儲存 .save才會寫進資料庫 跟new一樣
        # 手動作出一個sku 放到實體變數product中，讓我們在填入form helper時，順便生成sku
    end
    
    def create # 以POST方法送出 後台 新增商品頁面 中所填入的資料 所對應的action
        # admin_products    POST     /admin/products(.:format)      admin/products#create
        @product = Product.new(product_parms)
        # 傳入清洗過後的參數，新建product物件

        if @product.save
            redirect_to admin_products_path, notice: "商品資料新增成功"
        else
            render :new
            # 去new這個頁面，重新渲染一次（不是重新執行new方法（action）），是請view中的new頁面重畫一次
            # 本質上還是在create這個action中，並非執行new action
            # render就是要借new.html檔案來用
            # new.html檔案需要＠product 實體變數（所以才會在create action中，也寫一個跟new action中相同的 ＠product實體變數）（但也有 沒 這麼剛好（有同名實體變數）的狀況）
            # 這裡抓到的 ＠product實體變數 已經不像new action中是新創出來的，是裡頭已經有料（product_params）的 物件、model
        end
    end

    def edit
    end

    def update
        if @product.update(product_parms)
            redirect_to  edit_admin_product_path(@product), notice: "商品資料更新成功"
        else
            render :edit
        end
    end

    def destroy
        @product.destroy
        redirect_to admin_products_path, notice: "商品資料已刪除"
    end

    private

    def product_parms # 清洗參數
        params.require(:product).permit(:name, 
                                        :vendor_id,
                                        :list_price,
                                        :sell_price,
                                        :on_sell,
                                        :cover_image,
                                        :category_id,
                                        :description,
                                        skus_attributes: [
                                            :id, :spec, :quantity, :_destroy
                                        ])
        # 雖然 description 只是 action text的虛擬欄位 但一樣會被過濾掉，所以要來這裡加上，讓其可以順利通過強參數
        # model中accepts_nested_attributes_for :skus
        # skus_attributes: 為key，其值為一陣列
        # :_destroy 刪除庫存的時候 會有此參數 所以要讓他可通過
        # _destroy 欄位送到後端 有值時 資料庫就會刪除該資料 而非更新
    end

    def find_product
        @product = Product.friendly.find(params[:id])
        # 網址中原id已經被friendly id轉換（轉換為商品code），故要加上.friendly轉換
        # 拿id去match slug（我們設定為 商品資料表的code欄位）
    end

end
