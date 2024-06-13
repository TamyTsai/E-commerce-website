class CategoriesController < ApplicationController

    def show # 單一商品分類頁面 對應的action
        @category = Category.find(params[:id])
        # 先 根據抓到的id（網址沒用friendly id轉換過 所以其實就是網址上的id） 得知 目前是在哪個 單一商品類別 的 頁面
    end

end
