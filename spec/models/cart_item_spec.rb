# $ rails g rspec:model CartItem

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  it "每個 Cart Item 都可以計算它自己的金額（小計）" do
    # Arrange
    cart = Cart.new
    p1 = create(:product, sell_price: 5) 
    # 用factory bot產生假商品資料
    # 雖然有設定工廠產生的商品假資料 但資料內容其實可以被覆寫
    # 單獨設定售價欄位指定為5
    p2 = create(:product, sell_price: 10)

    # Action
    3.times { cart.add_item(p1.id) }
    2.times { cart.add_item(p2.id) }

    # Assert
    expect(cart.items.first.total_price).to eq 15 # 1號商品5元 購物車有3個1號商品 所以總共15元
    expect(cart.items.last.total_price).to eq 20
    # to be 是比較是否為同一個東西（記憶體位置 是否為 同一個） 非比較 值 （所以 15 和 0.15e2（科學記號表示法） 被判定為不同 無法通過測試）
    # to eq 則比較值（內容物）
  end
end

# $ rspec spec/models/cart_item_spec.rb