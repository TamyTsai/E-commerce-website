# $ rails g model Vendor title description:text online:boolean

class CreateVendors < ActiveRecord::Migration[6.1]
  def change
    create_table :vendors do |t|
      t.string :title # 廠商名稱
      t.text :description # 廠商描述
      t.boolean :online, default: true # 廠商是否 營業中（預設為 營業中）
      # 沒加預設值的話 沒填資料時就是nil

      t.timestamps
    end
  end
end


# rails db:migrate
# == 20240610043226 CreateVendors: migrating ====================================
# -- create_table(:vendors)
# -> 0.0043s
# == 20240610043226 CreateVendors: migrated (0.0043s) ===========================