# $ rails g migration add_category_to_products category:belongs_to
# category:belongs_to 會長出 category_id 欄位 且更清楚知道product是屬於category_id

class AddCategoryToProducts < ActiveRecord::Migration[6.1]
  def change
    # add_reference :products, :category, null: false, foreign_key: true
    add_reference :products, :category, foreign_key: true
    # 目前已經有一些商品分類存在 且還沒有id 所以設定null: false 會有問題
  end
end

# $ rails db:migrate
# -- add_reference(:products, :category, {:foreign_key=>true})
#    -> 0.0079s