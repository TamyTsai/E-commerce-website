class ProductsController < ApplicationController
    def index # 商品清單頁面 所對應的 action
        @products = Product.order(updated_at: :desc).includes(:vendor)
        # 為了顯示 N 筆 商品 所關連的 廠商 的名稱資料，額外多做了 5 次的資料庫查詢（最後一次因為已經查詢過所以是 Cache），
        # 這就是所謂的 N + 1 查詢（1 次 商品 查詢 + N 次的關連資料查詢），這對資料庫來說是很浪費的。
        # 在 Rails 裡可使用 includes 方法來減少不必要的資料庫查詢。
    end

    def show # 檢視單一商品頁面 所對應的 action
    end

end
