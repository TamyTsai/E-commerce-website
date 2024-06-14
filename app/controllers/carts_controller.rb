# $ rails g controller carts

class CartsController < ApplicationController

    before_action :authenticate_user!
    # authenticate_user!為devise的方法，會檢查當前使用者登入狀況 沒有登入的就踢到登入頁面

    def show
    end

end
