# rails g model Product name vendor:belongs_to list_price:decimal sell_price:decimal on_sell:boolean code deleted_at:datetime

class Product < ApplicationRecord
  belongs_to :vendor
end
