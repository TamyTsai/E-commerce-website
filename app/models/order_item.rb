class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :sku

  def total_price # 每一張訂單的小計金額
    quantity * sku.product.sell_price
    # order_items資料表有quantity欄位
    # 利用sku方法 反查 商品資料表 價格欄位
  end

end
