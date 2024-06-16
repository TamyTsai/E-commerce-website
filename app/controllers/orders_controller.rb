# $ rails g controller orders

class OrdersController < ApplicationController

    # require 'securerandom'
    # The Ruby language has built-in support for generating Version 4 UUIDs
    #  we require the securerandom library that is part of the Ruby standard library. The require give us access to the SecureRandom module.

    before_action :authenticate_user!
    # authenticate_user!為devise的方法，會檢查當前使用者登入狀況 沒有登入的就踢到登入頁面

    def index
        @orders = current_user.orders.order(id: :desc)
    end

    def create # 付款reserve

        # 訂單資訊（僅收件人等資訊，不含 訂單中商品項目）
        @order = current_user.orders.build(order_params)
        # 成立訂單

        current_cart.items.each do |item| # 將購物車中 的 商品項目 陣列 迭代 出來，一一存進 訂單資訊中
            @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
            # build 建立後在記憶體 還沒寫入資料庫
        end

        if @order.save # 若成功寫入資料庫

            # 打API傳送資料
            resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/request") do |req|
                # Failed to open TCP connection to :80 (Connection refused - connect(2) for nil port 80)
                # 設定完 ENV['line_pay_endpoint'] 要重開伺服器 要不然這個會變nil 就會變成對本機端打
                req.headers['Content-Type'] = 'application/json'
                req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
                req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret_key']
                req.body = {
                    productName: "電商網站",
                    # amount: current_cart.total_price.to_i,
                    amount: 500,
                    currency: "TWD",
                    confirmUrl: "http://localhost:3000/orders/confirm", # 交易成功後頁面要跳轉到哪 資訊會打回來這個地方
                    # 寫API路徑 專門去接line pay打回來的這包東西
                    # http://localhost:3000/orders/confirm?transactionId=2024061602141530410
                    orderId: @order.num
                }.to_json
            end

            # 收API回應資料
            # 用內建的ruby內建的parse解析回應的結果
            result = JSON.parse(resp.body)
            # 回應結果範例：
                # {
                #     "returnCode": "0000",
                #     "returnMessage": "Success.",
                #     "info": {
                #         "paymentUrl": {
                #             "web": "https://sandbox-web-pay.line.me/web/payment/wait?transactionReserveId=SURMMzh3Q1J1WjhBZjk5YkFPbzA1VmtUZ2FUcXo4TmdWa29rRXF6K0NsbVVJd0dvS01BZGdreGVQZ2k3cmpNMg",
                #             "app": "line://pay/payment/SURMMzh3Q1J1WjhBZjk5YkFPbzA1VmtUZ2FUcXo4TmdWa29rRXF6K0NsbVVJd0dvS01BZGdreGVQZ2k3cmpNMg"
                #         },
                #         "transactionId": 2024061602141330010,
                #         "paymentAccessToken": "356238494583"
                #     }
                # }

            if result["returnCode"] == "0000" # 若 付款reserve 成功
                payment_url = result["info"]["paymentUrl"]["web"]
                redirect_to payment_url
            else
                flash[:notice] = '付款發生錯誤'
                render 'carts/checkout'
                # 借carts/checkout.html.erb這個view來渲染頁面
            end

        end

    end

    def confirm # 付款完成 # 付款confirm
        # http://localhost:3000/orders/confirm?transactionId=2024061602141536210

        # 打 確認付款API 傳送資料
        resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/#{params[:transactionId]}/confirm") do |req|
            # Failed to open TCP connection to :80 (Connection refused - connect(2) for nil port 80)
            # 設定完 ENV['line_pay_endpoint'] 要重開伺服器 要不然這個會變nil 就會變成對本機端打
            req.headers['Content-Type'] = 'application/json'
            req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
            req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret_key']
            req.body = {
                # amount: current_cart.total_price.to_i,
                amount: 500,
                currency: "TWD",
            }.to_json
        end

        result = JSON.parse(resp.body)

        if result["returnCode"] == "0000" # 若 付款confirm 成功

            # 1.變更 訂單 狀態

            # 先抓要被變更的訂單（透過回傳的資料）
            order_id = result["info"]["orderId"] # 商家在付款 reserve 時傳送的訂單編號
            transaction_id = result["info"]["transactionId"] # 付款 reserve 後，做為 結果 所收到的 交易編號
            # 退款需要transaction id

            order = current_user.orders.find_by(num: order_id)
            order.pay!(transaction_id: transaction_id) # 使用aasm狀態機改變狀態，並且同時將transaction_id寫入 orders資料表transaction_id欄位（要在狀態機model寫before）

            # 2.清空 購物車
            session[:cart_tamy] = nil

            redirect_to root_path, notice: '付款已完成'
        else
            redirect_to root_path, notice: '付款發生錯誤'
        end

        # render html: id

        # rails c
            # [1] pry(main)> Order.find_by(num: 'dd7b633e7a')
            # NOTICE:  identifier "spring app    | 電商網站 | started 0 secs ago | development mode" will be truncated to "spring app    | 電商網站 | started 0 secs ago | development"
            # Order Load (0.5ms)  SELECT "orders".* FROM "orders" WHERE "orders"."num" = $1 LIMIT $2  [["num", "dd7b633e7a"], ["LIMIT", 1]]
            # => #<Order:0x00000001602f72e8
            # id: 8,
            # num: "dd7b633e7a",
            # recipient: "Carry",
            # tel: "0912345678",
            # address: "臺北市火星區",
            # note: "",
            # user_id: 1,
            # state: "paid",
            # paid_at: Sun, 16 Jun 2024 03:25:23.723719000 UTC +00:00,
            # transaction_id: "2024061602141555810",
            # created_at: Sun, 16 Jun 2024 03:24:53.943630000 UTC +00:00,
            # updated_at: Sun, 16 Jun 2024 03:25:23.725032000 UTC +00:00>
    end

    def cancel # 取消訂單按鈕 對應之action # 退款
        # 抓到要取消的訂單
        @order = current_user.orders.find(params[:id])

        if @order.paid? # 如果訂單為 已付款 狀態
            # 打 退款API 傳送資料
            resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/#{@order.transaction_id}/refund") do |req|
                # Failed to open TCP connection to :80 (Connection refused - connect(2) for nil port 80)
                # 設定完 ENV['line_pay_endpoint'] 要重開伺服器 要不然這個會變nil 就會變成對本機端打
                req.headers['Content-Type'] = 'application/json'
                req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
                req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret_key']
            end

            # 收API回應資料
            # 用內建的ruby內建的parse解析回應的結果
            result = JSON.parse(resp.body)

            if result["returnCode"] == "0000" # 若退款成功
                @order.cancel! # 將訂單狀態變更為 已取消
                redirect_to orders_path, notice: "訂單（訂單編號：#{@order.num}）已取消，並完成退款！"
            else
                redirect_to orders_path, notice: '退款發生錯誤'
            end

        else # 如果訂單非 已付款 狀態
            @order.cancel! # 將訂單 取消 狀態變更為 已取消
            redirect_to orders_path, notice: "訂單（訂單編號：#{@order.num}）已取消！"
        end

    end

    def pay # 手機 按下 付款按鈕 對應之action
        # 抓到要付款的訂單
        @order = current_user.orders.find(params[:id])

        # 打API傳送資料
        resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/request") do |req|
            # Failed to open TCP connection to :80 (Connection refused - connect(2) for nil port 80)
            # 設定完 ENV['line_pay_endpoint'] 要重開伺服器 要不然這個會變nil 就會變成對本機端打
            req.headers['Content-Type'] = 'application/json'
            req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
            req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret_key']
            req.body = {
                productName: "電商網站",
                # amount: @order.total_price.to_i,
                amount: 500,
                currency: "TWD",
                confirmUrl: "http://localhost:3000/orders/#{@order.id}/pay_confirm", # 交易成功後頁面要跳轉到哪 資訊會打回來這個地方
                # 寫API路徑 專門去接line pay打回來的這包東西
                # http://localhost:3000/orders/confirm?transactionId=2024061602141530410
                orderId: @order.num
            }.to_json
        end

        # 收API回應資料
        # 用內建的ruby內建的parse解析回應的結果
        result = JSON.parse(resp.body)

        if result["returnCode"] == "0000" # 若 付款reserve 成功
            payment_url = result["info"]["paymentUrl"]["web"]
            redirect_to payment_url
        else
            redirect_to orders_path, notice: '付款發生錯誤'
        end
    end

    def pay_confirm # 以 手機 付款完成後 api打回來的地方
        @order = current_user.orders.find(params[:id])

        # 打 確認付款API 傳送資料
        resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/#{params[:transactionId]}/confirm") do |req|
            # Failed to open TCP connection to :80 (Connection refused - connect(2) for nil port 80)
            # 設定完 ENV['line_pay_endpoint'] 要重開伺服器 要不然這個會變nil 就會變成對本機端打
            req.headers['Content-Type'] = 'application/json'
            req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
            req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret_key']
            req.body = {
                # amount: @order.total_price.to_i,
                amount: 500,
                currency: "TWD",
            }.to_json
        end

        result = JSON.parse(resp.body)

        if result["returnCode"] == "0000" # 若 付款confirm 成功

            # 1.變更 訂單 狀態

            # 先抓要被變更的訂單（透過回傳的資料）（本action 有先抓過 所以這裡不用）
            # order_id = result["info"]["orderId"] # 商家在付款 reserve 時傳送的訂單編號
            transaction_id = result["info"]["transactionId"] # 付款 reserve 後，做為 結果 所收到的 交易編號
            # 退款需要transaction id

            # order = current_user.orders.find_by(num: order_id)
            @order.pay!(transaction_id: transaction_id) # 使用aasm狀態機改變狀態，並且同時將transaction_id寫入 orders資料表transaction_id欄位（要在狀態機model寫before）

            # 2.清空 購物車（這個階段沒有購物車了）
            # session[:cart_tamy] = nil

            redirect_to orders_path, notice: '付款已完成'
        else
            redirect_to orders_path, notice: '付款發生錯誤'
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
