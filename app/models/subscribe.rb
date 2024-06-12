class Subscribe < ApplicationRecord
    validates :email, uniqueness: true # 在model層級 也驗證為唯一
end
