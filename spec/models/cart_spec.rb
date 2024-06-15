# $ rails g rspec:model Cart
# 測試不保證程式可以正常運作，但若測試不通過，表示程式一定被改壞了
# 測試的重點在 程式有問題時 可以很快抓出問題在哪
# 因為我們用 Rspec 取代原本內建的測試，所以原本專案裡的 test 目錄可移除
# $ rspec 跑 全部 測試
# $ rspec spec/models/cart_spec.rb 跑 特定檔案 測試
# $ rspec spec/models/cart_spec.rb:24 跑 特定檔案 特定行數附近 測試

require 'rails_helper'
# 會把 Rails環境 相關的東西載入，讓你測試時可以用到整個Rails的 model 物件 library等

RSpec.describe Cart, type: :model do

  # before(:each) do # 在每一個測試之前都做...
  #   @cart = Cart.new # 但這樣下面全部要改成實體變數
  # end
  # 可以寫成let(符號) {在每一個測試之前都執行的程式碼（值會指定給前面的符號）} 
  let(:cart) { Cart.new }

  describe "基本功能" do # 寫 describe 或 context（情境）都可以

    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了" do # it "要測試的內容描述" （此內容描述的字串 會被轉換成 方法）
      # 寫測試之3A原則：Arrange（安排）、Act（操作使用）、Assert（斷言 看看符不符合預期）
      # Arrange（安排）
      # cart = Cart.new # 寫測試的當下還沒有Cart model，但可以假設已經有了（先寫下要做什麼事和預期的結果，再一步步實作，邊做邊跑測試，看每一步實作有無符合預期）
      # Act（操作使用）
      cart.add_sku(2) # 丟2號商品（product_id = 2）進購物車
      # Assert（斷言 看看符不符合預期）
      # expect(cart.empty?).to be false # 因為剛剛有把東西丟進購物車，所以預期現在購物車「不該」是空的
      # 問號方法 有特殊寫法
      expect(cart).not_to be_empty

      # $ rspec
      # 會去 跑 spec目錄下 所有 檔名最後為_spec的檔案
      # $ rspec spec/models/cart_spec.rb （只跑這個檔案）執行結果：
        # 還沒寫Cart model前
          # $ rspec spec/models/cart_spec.rb
          # NameError:
          # uninitialized constant Cart
        # 建立Cart model後
          # NoMethodError:
          #   undefined method `add_sku' for #<Cart:0x000000013f047a00>
        # 到Cart model建立add_sku方法後
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
      # cart = Cart.new
      # cart.rb有寫initialize方法，讓Cart.new一開始就建立@items = []

      # Act（操作使用）
      # 加3次1號商品到 購物車，加2次2號商品到 購物車
      3.times { cart.add_sku(1) }
      2.times {cart.add_sku(2)}
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

    it "商品可以放到購物車裡，也可以再拿出來" do # 放香蕉進去 還可以把香蕉再拿出來 不會拿出來變成蘋果
      # Arrange（安排）
      # cart = Cart.new
      # v1 = Vendor.create(title: '美好小吃店')
      # p1 = Product.create(name: '麵線', list_price:30 ,sell_price:25 ,vendor: v1) 
      # create會建立一筆資料，並直接寫入資料庫裡（寫入失敗時 會rollback回來）
      # 用真的model（跟rails資料庫有關的）建立物件
      # 跑測試的時候，資料不是寫到 正式資料庫
      # 會根據不同環境 寫到不同資料庫（開發、測試、生產）
      # database: Ecommerce_website_test

      # 廠商跟商品等測試用資料 可以用factory bot幫忙建
      # p1 = FactoryBot.create(:product)
      # 甚至可以縮寫成 p1 = create(:product)
      # 但要先在rails_helper裡寫config.include FactoryBot::Syntax::Methods
      # Factory bot wiki usage getting started
      p1 = FactoryBot.create(:product, :with_skus)
      # 產生有skus的商品（預設創出來的商品 有2個sku）

      # Act（操作使用）
      # cart.add_sku(p1.id)
      cart.add_sku(p1.skus.first.id)
      # 在購物車加入 sku_id 為 第一個商品的第一個sku的id 的商品

      # Assert（斷言 看看符不符合預期）
      expect(cart.items.first.product).to be_a Product # 丟一個商品進去 拿出來預期還是一個商品
      # .product方法要去CartItem model做

      # p v1
      # p p1
      # #<Vendor id: 5, title: "美好小吃店", description: nil, online: true, created_at: "2024-06-13 13:45:26.996081000 +0000", updated_at: "2024-06-13 13:45:26.996081000 +0000", deleted_at: nil>
      # #<Product id: 2, name: "麵線", vendor_id: 5, list_price: 0.3e2, sell_price: 0.25e2, on_sell: false, code: "bb418d5fd5d7dc54dffb", deleted_at: nil, created_at: "2024-06-13 13:45:27.159405000 +0000", updated_at: "2024-06-13 13:45:27.159405000 +0000", category_id: nil>

    end

    it "可以計算整台購物車的總消費金額" do
      # Arrange
      # cart = Cart.new
      p1 = create(:product, :with_skus, sell_price: 5) 
      p2 = create(:product, :with_skus, sell_price: 10)

      # Action
      3.times { cart.add_sku(p1.skus.first.id) }
      2.times { cart.add_sku(p2.skus.first.id) }

      # Assert
      expect(cart.total_price).to eq 35

    end
  end

  describe "進階功能" do
    it "可以將購物車內容轉換成 Hash，以方便存到 Session 裡" do
      # Arrange
      # cart = Cart.new
      p1 = create(:product, :with_skus) 
      p2 = create(:product, :with_skus)

      # Action
      3.times { cart.add_sku(p1.id) }
      2.times { cart.add_sku(p2.id) }

      # Assert
      expect(cart.serialize).to eq cart_hash # 預期 購物車物件 轉換為 hash 後，會跟 cart_hash方法 回傳的hash內容一樣
      # .serialize方法 將購物車物件 轉換為 hash的方法
    end

    # 購物車原本是一個物件，但透過http移動傳輸的過程中會變成純文字，無法轉換回物件
    # 存到session的話 就可以每個頁面都抓得到

    it "可以把 Session 的內容（Hash 格式），還原成購物車的內容" do
      # Arrange、Action
      cart = Cart.from_hash(cart_hash) # 做一台購物車 裡面有東西 且內容物為cart_hash方法的內容（內容為一個hash）由hash轉換回來的結果
      # from_hash（從hash還原成購物車）是一個類別方法，作用在類別上（這個方法要自己寫）

      expect(cart.items.first.quantity).to eq 3
    end

    private
    
    def cart_hash # 購物車物件 轉換成的hash
      {
        "items" => [
          {"sku_id" => 1, "quantity" => 3}, # 1號商品有3個
          {"sku_id" => 2, "quantity" => 2},
        ]
      }
      # 購物車是一個物件，在記憶體算有一個位置，但想把其轉換成hash格式，希望hash透過serialize方法（要自己寫）可再轉換為原本的樣子（cart_hash）
      # hash中有items key，其value為 一個陣列，該陣列 裝著2個hash
      # 舊式hash寫法
    end

  end
end

# 可以把商品丟到到購物車裡，然後購物車裡就有東西了。
# 如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變。
# 商品可以放到購物車裡，也可以再拿出來。
# 每個 Cart Item 都可以計算它自己的金額（小計）。
# 可以計算整台購物車的總消費金額。
# 特別活動可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百或滿額免運費）。


