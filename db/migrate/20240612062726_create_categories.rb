# $ rails g model Category name deleted_at:datetime:index position:integer

class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name # 分類名稱
      t.datetime :deleted_at # 給軟刪除用的欄位 避免分類下的東西 在分類被刪除後 變成沒有分類
      t.integer :position # 分類的位置（給act as list套件用）

      t.timestamps
    end

    add_index :categories, :deleted_at

  end
end

# rails db:migrate
# -- create_table(:categories)
# -> 0.0043s
# -- add_index(:categories, :deleted_at)
# -> 0.0014s
