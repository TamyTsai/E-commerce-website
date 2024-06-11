# rails g model Product name vendor:belongs_to list_price:decimal sell_price:decimal on_sell:boolean code deleted_at:datetime

class Product < ApplicationRecord
  extend FriendlyId # 擴充 FriendlyId模組 中的方法，變成 類別方法（Product類別 的 方法）
  # friendly_id :name, use: :slugged
  # 用name欄位 產生slug，預設寫入 slug欄位
  friendly_id :code_generator, use: :slugged, slug_column: :code
  # 用code_generator方法產生slug，寫入 code欄位

  validates :name, presence: true # 驗證 商品名稱必填
  validates :list_price, :sell_price, numericality: { greater_than: 0, allow_nil: true}
  # 定價與售價欄位需為數字（Rails API可以查有哪些方法可用），數字可不填（還沒上架的商品 可能還沒確定價格），但填了一定要是大於零的數字
  validates :code, uniqueness: true # 於model層級也驗證code欄位值的唯一性

  
  belongs_to :vendor
  
  private
    def code_generator
      SecureRandom.hex(10) # 隨機跳20碼16進位數字
      # rails c
      # [1] pry(main)> SecureRandom.hex(5) 隨機跳10碼16進位數字
      # => "9801b8a884"
      # [2] pry(main)> SecureRandom.hex(6) 隨機跳12碼16進位數字
      # => "663d6af0c30a"
      # [3] pry(main)> SecureRandom.hex(7) 隨機跳14碼16進位數字
      # => "9265190fc59d95"
    end

end
