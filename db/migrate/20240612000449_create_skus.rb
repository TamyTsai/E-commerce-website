# rails g model Sku product:belongs_to spec quantity:integer deleted_at:datetime:index

class CreateSkus < ActiveRecord::Migration[6.1]
  def change
    create_table :skus do |t| # id
      t.belongs_to :product, null: false, foreign_key: true # product_id
      t.string :spec # 商品規格
      t.integer :quantity
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :skus, :deleted_at
  end
end

# rails db:migrate
# -- create_table(:skus)
# -> 0.0109s
# -- add_index(:skus, :deleted_at)
#    -> 0.0010s

