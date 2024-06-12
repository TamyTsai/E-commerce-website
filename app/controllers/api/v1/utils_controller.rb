# $ rails g controller api/v1/utils

class Api::V1::UtilsController < ApplicationController
    def subscribe
        render json: { status: 'ok' }
        # 回覆一個json格式檔案打api
    end
end
