# $ rails g migration add_deleted_at_to_vendors
# 如果後面直接打欄位名稱及欄位資料型態 rails就會根據檔名直接 把欄位加進檔名所指定的資料表
# $ rails g migration add_deleted_at_to_vendors deleted_at:datetime:index

class AddDeletedAtToVendors < ActiveRecord::Migration[6.1]
  def change
    add_column :vendors, :deleted_at, :datetime
    add_index :vendors, :deleted_at  # 因為每次讀取都會需要查詢此欄位，為了加快查詢速度，所以加上索引
  end
end

# $ rails db:migrate
# -- add_column(:vendors, :deleted_at, :datetime)
#    -> 0.0019s
# -- add_index(:vendors, :deleted_at)
#    -> 0.0018s

# 進控制台撈資料（預設篩選條件都會有"deleted_at" IS NULL）
# $ rails c
# [2] pry(main)> Vendor.all
# NOTICE:  identifier "spring app    | 電商網站 | started 0 secs ago | development mode" will be truncated to "spring app    | 電商網站 | started 0 secs ago | development"
# Vendor Load (0.5ms)  SELECT "vendors".* FROM "vendors" WHERE "vendors".「"deleted_at" IS NULL」
# => [#<Vendor:0x000000012ca92e28
# id: 2,
# title: "某某某書店",
# description: "賣很多書",
# online: true,
# created_at: Mon, 10 Jun 2024 06:19:45.627299000 UTC +00:00,
# updated_at: Mon, 10 Jun 2024 06:19:45.627299000 UTC +00:00,
# deleted_at: nil>,
# #<Vendor:0x000000012c9c33d0
# id: 1,
# title: "財源滾滾小賣部",
# description: "毛利率超高的公司~",
# online: true,
# created_at: Mon, 10 Jun 2024 06:16:47.482989000 UTC +00:00,
# updated_at: Mon, 10 Jun 2024 06:40:35.210501000 UTC +00:00,
# deleted_at: nil>]

# 進資料庫撈資料（被刪除的資料 還是看得到）
# $ rails db
# $ select * from vendors;
# Ecommerce_website_development=# select * from vendors;
#  id |     title      |    description    | online |         created_at         |         updated_at          | deleted_at 
#  ----+----------------+-------------------+--------+----------------------------+----------------------------+------------
#    2 | 某某某書店      |  賣很多書           | t      | 2024-06-10 06:19:45.627299 | 2024-06-10 06:19:45.627299 | 
#    1 | 財源滾滾小賣部   | 毛利率超高的公司~    | t      | 2024-06-10 06:16:47.482989 | 2024-06-10 06:40:35.210501 | 
#  (2 rows)

