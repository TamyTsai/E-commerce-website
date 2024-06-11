class Vendor < ApplicationRecord
    
    acts_as_paranoid

    validates :title, presence: true
    # 驗證 廠商名稱欄位必填
    # 後端驗證 寫進資料庫前的驗證

    # 方法前面加self就是類別方法，作用在類別上
    # def self.available
    #   where(online: true)
    # end

    # 類別方法的另一種寫法
    scope :available, -> { where(online: true) } # 用lambda實體化block
    # scope 把一群條件整理成一個scope（查詢範圍）
    # 簡化使用時的邏輯
    # 減少在controller中 寫一堆where組合
    # 用起來跟 類別方法 一樣
    # scope :類別方法名稱, -> { 類別方法的內容 }
end
