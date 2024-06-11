class Vendor < ApplicationRecord
    
    acts_as_paranoid

    validates :title, presence: true
    # 驗證 廠商名稱欄位必填
    # 後端驗證 寫進資料庫前的驗證
end
