class Order < ApplicationRecord
  belongs_to :user
  # 每張訂單 屬於 某個使用者
  has_many :order_items
  # 每張訂單 可有 多筆 訂單商品項目

  validates :recipient, :tel, :address, presence: true # 驗證 收件人、電話、地址 必填
  
end
