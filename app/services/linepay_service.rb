# 使用 Service Object
# 在 Rails 專案中，大部份的類別幾乎都繼承之 Rails 內建的上層類別，例如 Model 是繼承自 ActiveModel::Base、Controller 是繼承自 ActionController::Base …等，但其實並不是所有類別都必須要這樣設計。我們可以透過寫一些簡單的 Ruby 類別，把一些判斷的邏輯放在裡面。這樣簡單的純 Ruby 類別，通常又稱之 PORO（Plain Old Ruby Object）。

# 雖然說在 Rails 的 MVC 結構中，Model 好像也適合做這樣的事，但並不是所有的邏輯或功能都找得到一個合適的 Model 來擺放，舉例來說，各位覺得串接外部金流刷卡服務該放在哪個 Model 裡? 而且就算找得到合適的 Model 擺放，也可能會造成 Model 越來越大的情況，對整個專案來說不是好的發展。

# 幫「胖 Model（Fat Model）」減肥的做法之一，是把跟該 Model 看起來不相關功能的程式碼都拆出去放在另外的 Ruby 類別，需要使用的時候再拉進來使用，這樣除了可增加彈性且更容易重複使用外，這些程式碼也會因為另外拆出來而變得容易測試了。廣義的來說，你也可把 Service Object 也當做 Model 的一種。

# 設計 Service Object 類別
# Service Object 類別聽起來好像很複雜，但說穿了就只是一般的 PORO 類別而已，可能會在 new 的時候帶一些參數做為設定值（非必要），然後會有一些公開的實體方法（public instance method）來操作這些資料或與外部服務串接。

class LinepayService
    def initialize(api_type)
        @api_type = api_type
    end

    def perform(body) # 主要的動詞
        response = Faraday.post("#{ENV['line_pay_endpoint']}/v2#{@api_type}") do |req|
            # Failed to open TCP connection to :80 (Connection refused - connect(2) for nil port 80)
            # 設定完 ENV['line_pay_endpoint'] 要重開伺服器 要不然這個會變nil 就會變成對本機端打
            req.headers['Content-Type'] = 'application/json'
            req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
            req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret_key']
            req.body = body.to_json
        end

        @result = JSON.parse(response.body)        
    end

    def success?
        @result["returnCode"] == '0000'
    end

    def payment_url
        @result["info"]["paymentUrl"]["web"]
    end

    def order
        {
            order_id: @result["info"]["orderId"],
            transaction_id: @result["info"]["transactionId"]
        }
    end
end
