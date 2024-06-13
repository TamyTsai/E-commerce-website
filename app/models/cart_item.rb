class CartItem

    attr_reader :product_id, :quantity
    # 讓 實體變數 可在 實體外被讀取 其回傳之值

    # 既分類 也要 分數量
    def initialize(product_id, quantity = 1) 
    # 用此類別一建立實體（建立實體時就要帶入參數），該實體就會執行此方法，傳給new方法 的 引數，由initialize方法接收
    # 參數引數數量要對得上，否則會發生引數個數錯誤，但參數有預設值時，就不一定要傳引數進去
    # 如果沒寫要買幾個 就預設買一個
        @product_id = product_id # 建立一個實體變數 存放 傳進來的參數
        @quantity = quantity
    end

    # 增加商品數量的方法
    def increment!(n = 1)
        # 沒帶參數的話 預設加1個商品
        @quantity += n
        # 把 @quantity+n 的值 指定給 原@quantity
    end
    
end