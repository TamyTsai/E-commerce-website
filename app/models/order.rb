class Order < ApplicationRecord
  belongs_to :user
  # 每張訂單 屬於 某個使用者
  has_many :order_items
  # 每張訂單 可有 多筆 訂單商品項目

  validates :recipient, :tel, :address, presence: true # 驗證 收件人、電話、地址 必填
  
  before_create :generate_order_num
  # 在 訂單 建立之前 產生訂單編號
  # 更新（update）的時候 不會重複產生

  private
  # 產生訂單編號
  def generate_order_num
    self.num = SecureRandom.hex(5) unless num
    # 如果還沒有訂單編號 再生成訂單編號
  end
end
