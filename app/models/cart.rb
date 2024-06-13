# PORO： Plain Old Ruby Object
# 純Ruby類別，並未如其他model一樣繼承ApplicationRecord的許多資料庫功能
# 不是所有的model都需要資料庫

class Cart # 所有的資料都不會存在資料庫中，只會存在這個 物件 裡面

    def add_item(product_id)
    end

    def empty?
        false # 省略return之寫法
        # 呼叫方法時 預設回傳最後一行
    end

end