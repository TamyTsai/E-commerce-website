# $ rails g rspec:model Cart
# 測試不保證程式可以正常運作，但若測試不通過，表示程式一定被改壞了
# 測試的重點在 程式有問題時 可以很快抓出問題在哪

require 'rails_helper'
# 會把 Rails環境 相關的東西載入，讓你測試時可以用到整個Rails的 model 物件 library等

RSpec.describe Cart, type: :model do

  describe "基本功能" do # 寫 describe 或 context（情境）都可以

    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了" do # it "要測試的內容描述" （此內容描述的字串 會被轉換成 方法）
      # 寫測試之3A原則：Arrange（安排）、Act（操作使用）、Assert（斷言 看看符不符合預期）
      # Arrange（安排）
      cart = Cart.new # 寫測試的當下還沒有Cart model，但可以假設已經有了（先寫下要做什麼事和預期的結果，再一步步實作，邊做邊跑測試，看每一步實作有無符合預期）
      # Act（操作使用）
      cart.add_item(2) # 丟2號商品（product_id = 2）進購物車
      # Assert（斷言 看看符不符合預期）
      expect(cart.empty?).to be false # 因為剛剛有把東西丟進購物車，所以預期現在購物車「不該」是空的

      # $ rspec
      # 會去 跑 spec目錄下 所有 檔名最後為_spec的檔案
      # $ rspec spec/models/cart_spec.rb （只跑這個檔案）執行結果：
        # 還沒寫Cart model前
          # $ rspec spec/models/cart_spec.rb
          # NameError:
          # uninitialized constant Cart
        # 建立Cart model後
          # NoMethodError:
          #   undefined method `add_item' for #<Cart:0x000000013f047a00>
        # 到Cart model建立add_item方法後
          # NoMethodError:
          #   undefined method `empty?' for #<Cart:0x000000011039ed68>
        # 到Cart model建立empty?方法後
          # expected false
          #      got nil
        # 在Cart model empty?方法內容 寫上 false 後
          # Cart
          #   基本功能
          #     可以把商品丟到到購物車裡，然後購物車裡就有東西了
          
          # Finished in 0.00712 seconds (files took 0.81915 seconds to load)
          # 1 example, 0 failures

    end

    it "加相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      # Arrange（安排）
      cart = Cart.new
      # cart.rb有寫initialize方法，讓Cart.new一開始就建立@items = []

      # Act（操作使用）
      # 加3次1號商品到 購物車，加2次2號商品到 購物車
      3.times { cart.add_item(1) }
      2.times {cart.add_item(2)}
      # {} 為程式碼區塊（block），結合律比do...end強

      # Assert（斷言 看看符不符合預期）
      expect(cart.items.count).to be 2 # 預期只有2個商品「項目」 # items是陣列（@items = []） 所以可以使用count方法 計算 元素數量
      expect(cart.items.first.quantity).to be 3 # 預期 第一個商品項目（1號商品）的數量為3（只能對 單一商品項目 算商品數量，不能直接對 所有商品項目 用數量(quantity)方法）

      # 測試結果
        # 沒 將@item設定為實體外部可讀取 前
          # NoMethodError:
          #   undefined method `items' for #<Cart:0x000000014376e870 @item=[1, 1, 1, 2, 2]>
        # 將@item設定為實體外部可讀取 後
          # expected #<Integer:5> => 2 （因為目前是寫@items << product_id 沒有依據商品id做分類，所以放5個商品，就有5個商品項目）
          #       got #<Integer:11> => 5
        
          # Compared using equal?, which compares object identity,
          # but expected and actual are not the same object. Use
          # `expect(actual).to eq(expected)` if you don't care about
          # object identity in this example.
        # 設定CartItem model並設定相關方法後
          # Cart
          #   基本功能
          #     可以把商品丟到到購物車裡，然後購物車裡就有東西了
          #     加相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變
          
          # Finished in 0.0082 seconds (files took 0.81841 seconds to load)
          # 2 examples, 0 failures
    end

  end

  describe "進階功能" do
  end

end

# 可以把商品丟到到購物車裡，然後購物車裡就有東西了。
# 如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變。
# 商品可以放到購物車裡，也可以再拿出來。
# 每個 Cart Item 都可以計算它自己的金額（小計）。
# 可以計算整台購物車的總消費金額。
# 特別活動可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百或滿額免運費）。
