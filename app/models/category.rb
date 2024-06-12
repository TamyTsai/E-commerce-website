class Category < ApplicationRecord

    acts_as_paranoid
    
    has_many: products
    # 每個分類 可有 很多商品

    validates :name, presence: true
end
