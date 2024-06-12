# rails g model Product name vendor:belongs_to list_price:decimal sell_price:decimal on_sell:boolean code deleted_at:datetime

class Product < ApplicationRecord
  # extend FriendlyId # 擴充 FriendlyId模組 中的方法，變成 類別方法（Product類別 的 方法）
  # friendly_id :name, use: :slugged
  # 用name欄位 產生slug，預設寫入 slug欄位
  # friendly_id :code_generator, use: :slugged, slug_column: :code
  # 用code_generator方法產生slug，寫入 code欄位
  # friendly id功能不只商品會用到，廠商等也會用到，所以將 整段程式碼 整理到concerns，讓程式碼可以不用重覆寫，提升再用性
  include CodeGenerator

  acts_as_paranoid

  has_rich_text :description # 不用真的去開description欄位 他是一個虛擬欄位

  validates :name, presence: true # 驗證 商品名稱必填
  validates :list_price, :sell_price, numericality: { greater_than: 0, allow_nil: true}
  # 定價與售價欄位需為數字（Rails API可以查有哪些方法可用），數字可不填（還沒上架的商品 可能還沒確定價格），但填了一定要是大於零的數字
  validates :code, uniqueness: true # 於model層級也驗證code欄位值的唯一性

  
  belongs_to :vendor
  has_many :skus
  # 一個商品可有 多個存貨單位（stock keeping unit，SKU）
  accepts_nested_attributes_for :skus, reject_if: :all_blank, allow_destroy: true
  # https://guides.rubyonrails.org/form_helpers.html#configuring-the-model
  # 第10章節
  # 可以有很多巢狀屬性 都是關於sku的
  # reject_if: :all_blank, allow_destroy: true ：若資訊完全是空的 就不允許寫入、允許刪除
  
  # private
    # def code_generator
    #   SecureRandom.hex(10) # 隨機跳20碼16進位數字
    #   # rails c
    #   # [1] pry(main)> SecureRandom.hex(5) 隨機跳10碼16進位數字
    #   # => "9801b8a884"
    #   # [2] pry(main)> SecureRandom.hex(6) 隨機跳12碼16進位數字
    #   # => "663d6af0c30a"
    #   # [3] pry(main)> SecureRandom.hex(7) 隨機跳14碼16進位數字
    #   # => "9265190fc59d95"
    # end
    # friendly id功能不只商品會用到，廠商等也會用到，所以將 整段程式碼 整理到concerns，讓程式碼可以不用重覆寫，提升再用性

end

