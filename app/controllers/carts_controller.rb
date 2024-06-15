# $ rails g controller carts

class CartsController < ApplicationController

    before_action :authenticate_user!
    # authenticate_user!為devise的方法，會檢查當前使用者登入狀況 沒有登入的就踢到登入頁面

    def show
    end

    def destroy # 清空購物車按鈕連結 對應的action
        session[:cart_tamy] = nil
        # 將session（存有 由購物車物件 轉換成的 hash）設定成 nil，就清掉購物車了
        # 抓到session中cart key的value
        # session[:cart] = nil   session是一個hash，裡面有很多東西，只是用了其中一小部分存放購物車，所以如果清掉整個session，可能會連登入的狀態都清掉
        redirect_to root_path, notice: '購物車已清空'
    end

    def checkout # 點擊結帳按鈕連結 對應的action
    end

end
