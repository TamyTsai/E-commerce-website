# PORO： Plain Old Ruby Object
# 純Ruby類別，並未如其他model一樣繼承ApplicationRecord的許多資料庫功能
# 不是所有的model都需要資料庫
# 所有的 資料、狀態、行為 都不會存在資料庫中，只會存在 類別 裡面

class Cart # 所有的資料都不會存在資料庫中，只會存在這個 物件 裡面

    attr_reader :items
    # 讓@items實體變數 可在 實體外被讀取 其回傳之值

    # def initialize # 用此類別（Cart）建立的物件，一建立(.new) 就會直接執行intialize這個特殊方法
    #     @items = [] # 新建立一個空陣列
    #     # 如果把 @items = [] 寫在add_item中，就會變成每次加商品到購物車，購物車都會先被清空成空陣列
    #     # 但總是要有一個陣列可以放商品，所以就寫在initialize中，讓Cart.new時，就有空陣列
    #     # 實體變數不能直接在外部被取用（實體變數 在 實體內 可自由取用，在 實體外 就不行了），所以要建立getter或用attr_reader
    # end

    def initialize(items = []) # 沒給購物車陣列 就 給空陣列
        @items = items # 有給購物車陣列 new購物車物件時 就生成一台 一開始就有東西的購物車物件
    end

    def add_sku(sku_id)

        found = @items.find { |item| item.sku_id == sku_id}
        # item有兩個屬性（商品id 與 數量）
        # 翻陣列中（@items）中每個元素（item）看裡面 有沒有sku_id屬性（cart item的sku_id） 等於 此方法傳進來的參數（sku_id） 的
        # find不是rails資料庫才有的方法，irb就有了，所以雖然這裡是PORO類別，但一樣有得用
            # 2.7.8 :001 > list = ['a', 'b', 'c']  陣列
            # => ["a", "b", "c"] 
            # 2.7.8 :002 > list.find { |x| x == 'a' }
            # => "a" 
            # 2.7.8 :003 > list.find { |x| x == 'd' }
            # => nil 
        
        if found # 如果在cart item陣列中 有找到該商品id（要新增的商品項目 已存在於購物車（@items陣列）中）
            found.increment!
            # 對found物件使用increment!方法（自己寫在CartItem的實體方法）
        else # 如果在cart item陣列中沒找到該商品id
            @items << CartItem.new(sku_id)
            # 在陣列的最後面加上 以CartItem類別新建立物件 元素（作用如同.push(sku_id)）
        end
    end

    def empty?
        @items.empty?
        # 陣列本來就有empty?方法可用
        # empty?會回傳陣列是否為空

        # false # 省略return之寫法
        # 呼叫方法時 預設回傳最後一行
    end

    # def items # getter
    #     return @items
    # end

    # 計算所有商品總價的方法
    def total_price
        
        # total = 0
        # @items.each do |item|
        #     # cart裡面會有很多items，每個items都是一個陣列
        #     total += item.total_price
        #     # 將每個item的總價（小計）指定給total
        #     # 透過此迴圈就可以把items陣列中每個元素item的小計金額加總 給 total
        # end

        # total # 省略return的寫法

        @items.reduce(0) { |sum, item| sum = sum + item.total_price }
        # sum = 可省略
        # reduce()對集合裡 的 每個元素 進行運算，並將 所有的運算結果 歸納成 一個 單一結果
        # 同意詞：inject
        # reduce(0) 初始值為0（沒有給預設值的話 會拿第一個元素（item）當預設值 但這裡item不能拿來加總）
        # sum, item ：累加後之值、每個項目
        # 每次計算完就會回傳sum，然後再做下一次的迴圈，最後得到歸納值
    end

    # 將 購物車物件 轉換為hash的方法
    def serialize
        # items = [
        #     {"sku_id" => 1, "quantity" => 3},
        #     {"sku_id" => 2, "quantity" => 2},
        # ]

        items = @items.map { |item| {"sku_id" => item.sku_id, "quantity" => item.quantity} }
        # .map方法對 集合裡 的 每個元素 進行運算，並收集成 一個新的集合
        # items裡面每個元素都是一個cart item，cart item會有對應的 商品id 及 該商品數量 方法

        { "items" => items }

        # 跑測試時沒把資料庫清掉 可能會出現非預期結果
        # -"items" => [{"sku_id"=>1, "quantity"=>3}, {"sku_id"=>2, "quantity"=>2}],
    #    +"items" => [{"sku_id"=>49, "quantity"=>3}, {"sku_id"=>50, "quantity"=>2}],
    end

    # 將 hash 轉換回 購物車物件 的方法
    def self.from_hash(hash = nil) # 類別方法 # 給參數預設值 避免沒傳引數的時候 造成引數個數錯誤
        # 傳入的引數hash應有的樣子
        # {
        #     "items" => [
        #       {"sku_id" => 1, "quantity" => 3}, # 1號商品有3個
        #       {"sku_id" => 2, "quantity" => 2},
        #     ]
        # }

        # hash > "items" key > 陣列 > hash

        if hash && hash["items"] # 若有傳引數hash 且hash中有item這個key
            # 要將 傳入的hash轉換回 購物車物件
            items = hash["items"].map { |item| # hash["items"]會 對應 一個 由 兩個hash組成 的陣列，item是陣列中的元素，也就是 個別的hash
                CartItem.new(item["sku_id"], item["quantity"]) # item["sku_id"]可以拿到item hash 中 sku_id key所對應的值
            }
            # 用.map方法後 會得到陣列

            Cart.new(items) # 將items陣列作為 初始化方法參數 建立Cart物件

            # p items
            # [#<CartItem:0x00000001078252a0 @sku_id=1, @quantity=3>, #<CartItem:0x0000000107825278 @sku_id=2, @quantity=2>]
        else # 若沒傳引數hash 或 hash中沒有item這個key（格式錯誤）
            Cart.new # 給一個 全新 購物車物件
        end

    end

end