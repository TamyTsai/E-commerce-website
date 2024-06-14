FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    list_price { Faker::Number.between(from: 10, to: 100) }
    sell_price { Faker::Number.between(from: 1, to: 100) }
    on_sell { false }
    # code { "MyString" } # new的時候就會自動長了（hex(10)）（CodeGenerator model有寫方法 Product model有引入該模組）
    # category_id {}
    
    vendor
    # 縮寫 會去找vendors.rb工廠 幫你建廠商（檔名是複數 這裡是單數）
    category
  end
end

# $ RAILS_ENV=test rails c
  # [1] pry(main)> FactoryBot.build(:product)
  # => #<Product:0x0000000147b0de28
  #  id: nil,
  #  name: "Chantelle Christiansen",
  #  vendor_id: nil, （還沒資料）
  #  list_price: 0.44e2,
  #  sell_price: 0.7e2,
  #  on_sell: false,
  #  deleted_at: nil,
  #  created_at: nil,
  #  updated_at: nil,
  #  category_id: nil>
# $ RAILS_ENV=test rails c --sandbox 沙盒模式 重開資料庫後所有東西都會復原 所以可以隨便玩
  # p1 = FactoryBot.build(:product)
  # TRANSACTION (0.0ms)  BEGIN
  # => #<Product:0x0000000105c41688
  #  id: nil,
  #  name: "Nicolle McClure",
  #  vendor_id: nil, （還沒資料）
  #  list_price: 0.86e2,
  #  sell_price: 0.37e2,
  #  on_sell: false,
  #  code: "MyString",
  #  deleted_at: nil,
  #  created_at: nil,
  #  updated_at: nil,
  #  category_id: nil>
  # -----
  # p1.valid?
  # Product Exists? (13.0ms)  SELECT 1 AS one FROM "products" WHERE "products"."code" = $1 AND "products"."deleted_at" IS NULL LIMIT $2  [["code", "MyString"], ["LIMIT", 1]]
  # => true 廠商必填 然還沒寫進資料庫 所以沒填還是有效
  # ------
  # [4] pry(main)> p1.save
  #   TRANSACTION (0.4ms)  SAVEPOINT active_record_1
  #   Product Exists? (0.7ms)  SELECT 1 AS one FROM "products" WHERE "products"."code" = $1 AND "products"."deleted_at" IS NULL LIMIT $2  [["code", "MyString"], ["LIMIT", 1]]
  #   （商品寫入資料庫前前 先建立廠商）Vendor Create (5.2ms)  INSERT INTO "vendors" ("title", "description", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["title", "Shona Kris"], ["description", "Voluptatem magnam aut. Eligendi soluta est. Ut qui id."], ["created_at", "2024-06-14 00:13:15.136051"], ["updated_at", "2024-06-14 00:13:15.136051"]]
  #   Product Create (3.5ms)  INSERT INTO "products" ("name", "vendor_id", "list_price", "sell_price", "code", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING "id"  [["name", "Nicolle McClure"], ["vendor_id", 8], ["list_price", "86.0"], ["sell_price", "37.0"], ["code", "MyString"], ["created_at", "2024-06-14 00:13:15.143103"], ["updated_at", "2024-06-14 00:13:15.143103"]]
  #   TRANSACTION (0.2ms)  RELEASE SAVEPOINT active_record_1
  # => true 存檔成功
  # ------
  # [5] pry(main)> p1
  # => #<Product:0x0000000105c41688
  # id: 5,
  # name: "Nicolle McClure",
  # vendor_id: 8, 寫進資料庫就有廠商了
  # list_price: 0.86e2,
  # sell_price: 0.37e2,
  # on_sell: false,
  # code: "MyString",
  # deleted_at: nil,
  # created_at: Fri, 14 Jun 2024 00:13:15.143103000 UTC +00:00,
  # updated_at: Fri, 14 Jun 2024 00:13:15.143103000 UTC +00:00,
  # category_id: nil>
  # ------
  # [1] pry(main)> FactoryBot.create(:product) 直接create 這樣生商品資料時 需要的廠商資料就會一併被自動建立
  # TRANSACTION (0.0ms)  BEGIN
  # TRANSACTION (0.1ms)  SAVEPOINT active_record_1
  # Vendor Create (1.3ms)  INSERT INTO "vendors" ("title", "description", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["title", "Burton Luettgen"], ["description", "Cum recusandae quia. In vero quaerat. Quasi repellendus delectus."], ["created_at", "2024-06-14 00:21:19.251283"], ["updated_at", "2024-06-14 00:21:19.251283"]]
  # TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  # TRANSACTION (0.1ms)  SAVEPOINT active_record_1
  # Product Exists? (1.8ms)  SELECT 1 AS one FROM "products" WHERE "products"."id" IS NOT NULL AND "products"."code" = $1 LIMIT $2  [["code", "9e4368db8ef15140a041"], ["LIMIT", 1]]
  # Product Exists? (0.2ms)  SELECT 1 AS one FROM "products" WHERE "products"."code" = $1 AND "products"."deleted_at" IS NULL LIMIT $2  [["code", "9e4368db8ef15140a041"], ["LIMIT", 1]]
  # Product Create (2.0ms)  INSERT INTO "products" ("name", "vendor_id", "list_price", "sell_price", "code", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING "id"  [["name", "Wesley Ward"], ["vendor_id", 10], ["list_price", "22.0"], ["sell_price", "43.0"], ["code", "9e4368db8ef15140a041"], ["created_at", "2024-06-14 00:21:19.262263"], ["updated_at", "2024-06-14 00:21:19.262263"]]
  # TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  # => #<Product:0x000000012f3ed138
  # id: 6,
  # name: "Wesley Ward",
  # vendor_id: 10,
  # list_price: 0.22e2,
  # sell_price: 0.43e2,
  # on_sell: false,
  # code: "9e4368db8ef15140a041",
  # deleted_at: nil,
  # created_at: Fri, 14 Jun 2024 00:21:19.262263000 UTC +00:00,
  # updated_at: Fri, 14 Jun 2024 00:21:19.262263000 UTC +00:00,
  # category_id: nil>