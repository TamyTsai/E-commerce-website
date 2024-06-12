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
end
