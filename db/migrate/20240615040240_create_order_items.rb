# $ rails g model OrderItem order:belongs_to sku:belongs_to quantity:integer
# order items 資料表 存放 訂單含有之商品項目 資料
# 如同cart下有cart item，order下也做order item

class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.belongs_to :order, null: false, foreign_key: true
      t.belongs_to :sku, null: false, foreign_key: true # 對系統設定來說 sku是唯一的 透過sku可知商品的id、規格、庫存數量
      t.integer :quantity # 欲購買之商品數量

      t.timestamps
    end
  end
end

# rails db:migrate
# -- create_table(:order_items)
#    -> 0.0052s