# $ rails g controller api/v1/utils

class Api::V1::UtilsController < ApplicationController
    def subscribe
        email = params['subscribe']['email']
        # Parameters: {"subscribe"=>{"email"=>"aaa@ccc.com"}}
        # hash 中有個 subscribe key, value為另一個key email，vaule為aaa@ccc.com

        sub = Subscribe.new(email: email)

        if sub.save # email存檔成功後
            render json: { status: 'ok', email: email }
            # api被打後 回覆一個json格式檔案
            # status欄位（名稱隨便取）顯示ok
            # 並將接收並存檔成功的email回傳回去
        else # email存檔失敗後（通常是因為email重複而無法寫入）
            render json: { status: '已訂閱過電子報', email: email }
        end

        # 抓到透過api路徑打過來的資料 塞進去
        # 存檔成功...，存檔失敗...

    end

    def cart
        # 先找到商品
        # 前端透過api打來一包params資料，後端抓下來
        product = Product.friendly.find(params[:id])

        # 有找到使用者想丟進購物車的商品 才真的把該商品丟入購物車
        if product
            # cart = Cart.from_hash(session[:cart_tamy])
            # .from_hash(session[:cart_tamy]) 把 hash 還原為 購物車物件
            # 如果沒有這個hash的話 預設會建全新購物車
            # 寫一個current_cart方法（會回傳Cart.from_hash(session[:cart_tamy])）在 ApplicationController
            current_cart.add_item(product.code)

            session[:cart_tamy] = current_cart.serialize
            # 將購物車hash存到session中
            # session 可讓使用者跳轉到其他頁面時 仍繼續有 存到session的資料（一直存在瀏覽器中）
            # serialize可將 購物車物件 序列化為hash （自己寫的方法）
            # current_cart為 全新或有東西的 購物車物件

            render json: { status: 'ok', items: current_cart.items.count } # 要回給前端的東西（json檔）
        else
        end

        # render json: params
        # json格是的params內容會是：{id: "product.code", quantity: "2", sku: "8", controller: "api/v1/utils", action: "cart"}
    end

end
