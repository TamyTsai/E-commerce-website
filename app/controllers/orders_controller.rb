# $ rails g controller orders

class OrdersController < ApplicationController

    # require 'securerandom'
    # The Ruby language has built-in support for generating Version 4 UUIDs
    #  we require the securerandom library that is part of the Ruby standard library. The require give us access to the SecureRandom module.

    before_action :authenticate_user!
    # authenticate_user!為devise的方法，會檢查當前使用者登入狀況 沒有登入的就踢到登入頁面

    def create

        # 訂單資訊（僅收件人等資訊，不含 訂單中商品項目）
        @order = current_user.orders.build(order_params)

        current_cart.items.each do |item| # 將購物車中 的 商品項目 陣列 迭代 出來，一一存進 訂單資訊中
            @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
            # build 建立後在記憶體 還沒寫入資料庫
        end

        if @order.save # 若成功寫入資料庫

            resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/request") do |req|
                req.headers['Content-Type'] = 'application/json'
                req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
                req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret_key']
                req.body = {
                    productName: "五百倍大平台",
                    # amount: current_cart.total_price.to_i,
                    amount: 500,
                    currency: "TWD",
                    confirmUrl: "http://localhost:3000/orders/confirm", # 交易成功後頁面要跳轉到哪 資訊會打回來這個地方
                    # 寫API路徑 專門去接line pay打回來的這包東西
                    orderId: @order.num
                }.to_json
            end

            redirect_to root_path, notice: 'ok'
        else
            render 'carts/checkout'
            # 借carts/checkout.html.erb這個view來渲染頁面
        end

    end

    private

    def order_params # 資料清洗
        params.require(:order).permit(:recipient, :tel, :address, :note)
        # 在結帳頁面輸入訂單資訊 並 點擊使用line pay結帳按鈕後 翻log檔案可以看到按了按鈕會送什麼東西出來：
        # Parameters: {"authenticity_token"=>"[FILTERED]", "order"=>{"recipient"=>"Carry", "tel"=>"0912345678", "address"=>"臺北市火星區", "note"=>""}, "commit"=>"使用 Line Pay 結帳"}
        # 僅允許Parameters中的:recipient, :tel, :address, :note通過
    end

end
