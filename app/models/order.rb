class Order < ApplicationRecord

  include AASM

  belongs_to :user
  # 每張訂單 屬於 某個使用者
  has_many :order_items
  # 每張訂單 可有 多筆 訂單商品項目

  validates :recipient, :tel, :address, presence: true # 驗證 收件人、電話、地址 必填
  
  before_create :generate_order_num
  # 在 訂單 建立之前 產生訂單編號
  # 更新（update）的時候 不會重複產生

  aasm column: 'state' do # 要跟aasm說我們儲存狀態的欄位名稱為何 否則預設會去找aasm欄位
    state :pending, initial: true
    # 初始狀態 處理中（待付款）
    state :paid, :delivered, :cancelled
    # 已付款 運送中（已出貨） 已取消

    event :pay do # 付款
      transitions from: :pending, to: :paid

      before do |args| # 在pay動作之前要做的事
        # 執行pay!動作時 傳入的參數會進args
        self.transaction_id = args[:transaction_id]
        self.paid_at = Time.now
      end
    end

    event :deliver do
      transitions from: :paid, to: :delivered
    end

    event :cancel do
      transitions from: [:pending, :paid, :delivered], to: :cancelled
    end
  end

  def total_price # 所有訂單的總價
    order_items.reduce(0) { |sum, item| sum = sum + item.total_price }
    # has_many :order_items 所以有 order_items可用
    # sum = 可省略
    # reduce()對集合裡 的 每個元素 進行運算，並將 所有的運算結果 歸納成 一個 單一結果
    # 同意詞：inject
    # reduce(0) 初始值為0（沒有給預設值的話 會拿第一個元素（item）當預設值 但這裡item不能拿來加總）
    # sum, item ：累加後之值、每個項目
    # 每次計算完就會回傳sum，然後再做下一次的迴圈，最後得到歸納值
  end

  private
  # 產生訂單編號
  def generate_order_num
    self.num = SecureRandom.hex(5) unless num
    # 如果還沒有訂單編號 再生成訂單編號
  end
end
