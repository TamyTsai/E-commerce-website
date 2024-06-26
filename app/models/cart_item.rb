class CartItem

    attr_reader :sku_id, :quantity
    # 讓 實體變數 可在 實體外被讀取 其回傳之值

    # 既分類 也要 分數量
    def initialize(sku_id, quantity = 1) 
    # 用此類別一建立實體（建立實體時就要帶入參數），該實體就會執行此方法，傳給new方法 的 引數，由initialize方法接收
    # 參數引數數量要對得上，否則會發生引數個數錯誤，但參數有預設值時，就不一定要傳引數進去
    # 如果沒寫要買幾個 就預設買一個
        @sku_id = sku_id # 建立一個實體變數 存放 傳進來的參數
        @quantity = quantity
    end

    # 增加商品數量的方法
    def increment!(n = 1)
        # 沒帶參數的話 預設加1個商品
        @quantity += n
        # 把 @quantity+n 的值 指定給 原@quantity
    end

    # 回傳商品的方法
    def product
        # Product.find_by(id: sku_id)
        # Product.friendly.find(sku_id) # 找出對應的商品
        # 不過這裡已經知道商品id是多少了
        # find()出問題會噴例外 find_by()找不到時給nil

        Product.joins(:skus).find_by(skus: { id: sku_id } )
        # joins 水平合併表格（預設為inner join）
    end

    # 計算單項商品總價的方法
    def total_price
        product.sell_price * @quantity
        # product是呼叫上面那個product方法（Ruby呼叫方法可省略小括弧），找出對應的商品
    end
    
end