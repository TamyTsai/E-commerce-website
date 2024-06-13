# PORO： Plain Old Ruby Object
# 純Ruby類別，並未如其他model一樣繼承ApplicationRecord的許多資料庫功能
# 不是所有的model都需要資料庫
# 所有的 資料、狀態、行為 都不會存在資料庫中，只會存在 類別 裡面

class Cart # 所有的資料都不會存在資料庫中，只會存在這個 物件 裡面

    attr_reader :items
    # 讓@items實體變數 可在 實體外被讀取 其回傳之值

    def initialize # 用此類別（Cart）建立的物件，一建立(.new) 就會直接執行intialize這個特殊方法
        @items = [] # 新建立一個空陣列
        # 如果把 @items = [] 寫在add_item中，就會變成每次加商品到購物車，購物車都會先被清空成空陣列
        # 但總是要有一個陣列可以放商品，所以就寫在initialize中，讓Cart.new時，就有空陣列
        # 實體變數不能直接在外部被取用（實體變數 在 實體內 可自由取用，在 實體外 就不行了），所以要建立getter或用attr_reader
    end

    def add_item(product_id)

        found = @items.find { |item| item.product_id == product_id}
        # item有兩個屬性（商品id 與 數量）
        # 翻陣列中（@items）中每個元素（item）看裡面 有沒有product_id屬性（cart item的product_id） 等於 此方法傳進來的參數（product_id） 的
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
            @items << CartItem.new(product_id)
            # 在陣列的最後面加上 以CartItem類別新建立物件 元素（作用如同.push(product_id)）
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

end