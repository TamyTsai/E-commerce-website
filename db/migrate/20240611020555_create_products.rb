# rails g model Product name vendor:belongs_to list_price:decimal sell_price:decimal on_sell:boolean code deleted_at:datetime
# vendor:belongs_to 與 vendor:references 相同，都會長出 vendor_id: integer欄位出來
# belongs_to 在閱讀上 更清楚的知道 產品屬於廠商的
# 國外價格有可能會有小數點 保險一點還是用小數點類型資料型態
# 商品編號預設為商品id，但透過id就會被知道資料庫有幾個商品，若不想被知道，就另外編商品code（代碼）（字串資料型態）

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.belongs_to :vendor, null: false, foreign_key: true # 注意belongs_to和references都是長出 vendor_id欄位 非 vendor欄位
      t.decimal :list_price
      t.decimal :sell_price
      t.boolean :on_sell, default: false # 預設未上架
      t.string :code
      t.datetime :deleted_at

      t.timestamps
    end

      add_index :products, :deleted_at  # 因為每次讀取都會需要查詢此欄位，為了加快查詢速度，所以加上索引
      # add_index :要加在哪個資料表, :的哪個欄位
      add_index :products, :code, unique: true # 不希望商品代碼重複
      # 之前都是在 model層級 做後端驗證 是否重複，這邊是在 資料庫層級 就讓代碼不重複（重複的資料 一開始 就寫不進資料庫）（資料庫層級驗證）
  end
end


# rails db:migrate
# -- create_table(:products)
# -> 0.0086s
# -- add_index(:products, :deleted_at)
#    -> 0.0009s
# -- add_index(:products, :code, {:unique=>true})
#    -> 0.0008s