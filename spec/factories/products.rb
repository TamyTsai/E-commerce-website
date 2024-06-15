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

    trait :with_skus do
    # 到時候就可以用 FactoryBot.create(:product, :with_skus)建立擁有skus的商品
    # （平常是用 FactoryBot.create(:product)）

      transient do
        amount { 2 }
        # amount預設為2
      end

      skus { build_list :sku, amount }
      # build_list：rspec提供的語法
      # skus { build_list :sku, amount } 預設幫你建立2個sku
      # 到時候可以用 FactoryBot.create(:product, :with_skus, amount: n)建立擁有n個skus的商品
    end

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
# [1] pry(main)> p1 = FactoryBot.create(:product, :with_skus)
  # TRANSACTION (0.0ms)  BEGIN
  # TRANSACTION (0.1ms)  SAVEPOINT active_record_1
  # Vendor Create (3.2ms)  INSERT INTO "vendors" ("title", "description", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["title", "Sena Emard I"], ["description", "Occaecati a suscipit. Illo nulla iusto. Dolore officia eum."], ["created_at", "2024-06-15 10:30:38.561463"], ["updated_at", "2024-06-15 10:30:38.561463"]]
  # TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  # TRANSACTION (0.1ms)  SAVEPOINT active_record_1
  # Category Load (7.5ms)  SELECT "categories".* FROM "categories" WHERE (1 = 1) AND ("categories"."position" IS NOT NULL) ORDER BY "categories"."position" DESC LIMIT $1  [["LIMIT", 1]]
  # Category Create (12.8ms)  INSERT INTO "categories" ("name", "position", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Byron Mann"], ["position", 1], ["created_at", "2024-06-15 10:30:38.575101"], ["updated_at", "2024-06-15 10:30:38.575101"]]
  # TRANSACTION (1.7ms)  RELEASE SAVEPOINT active_record_1
  # TRANSACTION (2.2ms)  SAVEPOINT active_record_1
  # Product Exists? (2.5ms)  SELECT 1 AS one FROM "products" WHERE "products"."id" IS NOT NULL AND "products"."code" = $1 LIMIT $2  [["code", "ce7b3727d462dc56c7aa"], ["LIMIT", 1]]
  # Product Exists? (0.3ms)  SELECT 1 AS one FROM "products" WHERE "products"."code" = $1 AND "products"."deleted_at" IS NULL LIMIT $2  [["code", "ce7b3727d462dc56c7aa"], ["LIMIT", 1]]
  # Product Create (2.2ms)  INSERT INTO "products" ("name", "vendor_id", "list_price", "sell_price", "code", "created_at", "updated_at", "category_id") VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING "id"  [["name", "Aleisha Jakubowski"], ["vendor_id", 1], ["list_price", "69.0"], ["sell_price", "52.0"], ["code", "ce7b3727d462dc56c7aa"], ["created_at", "2024-06-15 10:30:38.622856"], ["updated_at", "2024-06-15 10:30:38.622856"], ["category_id", 1]]
  # Sku Create (1.2ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 1], ["spec", "Shelby Keebler"], ["quantity", 8], ["created_at", "2024-06-15 10:30:38.625719"], ["updated_at", "2024-06-15 10:30:38.625719"]]
  # Sku Create (0.2ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 1], ["spec", "Dorinda Koelpin"], ["quantity", 3], ["created_at", "2024-06-15 10:30:38.627220"], ["updated_at", "2024-06-15 10:30:38.627220"]]
  # Sku Create (0.3ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 1], ["spec", "Emile Roberts"], ["quantity", 4], ["created_at", "2024-06-15 10:30:38.627611"], ["updated_at", "2024-06-15 10:30:38.627611"]]
  # TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  # => #<Product:0x0000000155442220
  # id: 1,
  # name: "Aleisha Jakubowski",
  # vendor_id: 1,
  # list_price: 0.69e2,
  # sell_price: 0.52e2,
  # on_sell: false,
  # code: "ce7b3727d462dc56c7aa",
  # deleted_at: nil,
  # created_at: Sat, 15 Jun 2024 10:30:38.622856000 UTC +00:00,
  # updated_at: Sat, 15 Jun 2024 10:30:38.622856000 UTC +00:00,
  # category_id: 1>
  # -----------
  #   [2] pry(main)> p1.skus
  # => [#<Sku:0x00000001602d1e80
  #   id: 1,
  #   product_id: 1,
  #   spec: "Shelby Keebler",
  #   quantity: 8,
  #   deleted_at: nil,
  #   created_at: Sat, 15 Jun 2024 10:30:38.625719000 UTC +00:00,
  #   updated_at: Sat, 15 Jun 2024 10:30:38.625719000 UTC +00:00>,
  #  #<Sku:0x000000014565f428
  #   id: 2,
  #   product_id: 1,
  #   spec: "Dorinda Koelpin",
  #   quantity: 3,
  #   deleted_at: nil,
  #   created_at: Sat, 15 Jun 2024 10:30:38.627220000 UTC +00:00,
  #   updated_at: Sat, 15 Jun 2024 10:30:38.627220000 UTC +00:00>,
  #  #<Sku:0x00000001456a7278
  #   id: 3,
  #   product_id: 1,
  #   spec: "Emile Roberts",
  #   quantity: 4,
  #   deleted_at: nil,
  #   created_at: Sat, 15 Jun 2024 10:30:38.627611000 UTC +00:00,
  #   updated_at: Sat, 15 Jun 2024 10:30:38.627611000 UTC +00:00>]
  # ---------
  # [3] pry(main)> p1.skus.count
  #  (3.3ms)  SELECT COUNT(*) FROM "skus" WHERE "skus"."product_id" = $1  [["product_id", 1]]
  #  => 3
# [1] pry(main)> p2 = FactoryBot.create(:product, :with_skus, amount: 5)
  # TRANSACTION (0.0ms)  BEGIN
  #   TRANSACTION (0.1ms)  SAVEPOINT active_record_1
  #   Vendor Create (1.3ms)  INSERT INTO "vendors" ("title", "description", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["title", "Demarcus Rowe MD"], ["description", "Voluptas autem qui. Autem reprehenderit enim. Sed ut dolorum."], ["created_at", "2024-06-15 10:38:34.145752"], ["updated_at", "2024-06-15 10:38:34.145752"]]
  #   TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  #   TRANSACTION (0.1ms)  SAVEPOINT active_record_1
  #   Category Load (1.4ms)  SELECT "categories".* FROM "categories" WHERE (1 = 1) AND ("categories"."position" IS NOT NULL) ORDER BY "categories"."position" DESC LIMIT $1  [["LIMIT", 1]]
  #   Category Create (0.2ms)  INSERT INTO "categories" ("name", "position", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Miles Hintz"], ["position", 1], ["created_at", "2024-06-15 10:38:34.158577"], ["updated_at", "2024-06-15 10:38:34.158577"]]
  #   TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  #   TRANSACTION (0.2ms)  SAVEPOINT active_record_1
  #   Product Exists? (2.4ms)  SELECT 1 AS one FROM "products" WHERE "products"."id" IS NOT NULL AND "products"."code" = $1 LIMIT $2  [["code", "0909190f17f3de4bb4f1"], ["LIMIT", 1]]
  #   Product Exists? (0.3ms)  SELECT 1 AS one FROM "products" WHERE "products"."code" = $1 AND "products"."deleted_at" IS NULL LIMIT $2  [["code", "0909190f17f3de4bb4f1"], ["LIMIT", 1]]
  #   Product Create (1.2ms)  INSERT INTO "products" ("name", "vendor_id", "list_price", "sell_price", "code", "created_at", "updated_at", "category_id") VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING "id"  [["name", "Sen. Sheree Heaney"], ["vendor_id", 2], ["list_price", "53.0"], ["sell_price", "21.0"], ["code", "0909190f17f3de4bb4f1"], ["created_at", "2024-06-15 10:38:34.187021"], ["updated_at", "2024-06-15 10:38:34.187021"], ["category_id", 2]]
  #   Sku Create (0.7ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 2], ["spec", "Jackson Orn"], ["quantity", 7], ["created_at", "2024-06-15 10:38:34.188751"], ["updated_at", "2024-06-15 10:38:34.188751"]]
  #   Sku Create (0.3ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 2], ["spec", "Donny Bashirian"], ["quantity", 3], ["created_at", "2024-06-15 10:38:34.189755"], ["updated_at", "2024-06-15 10:38:34.189755"]]
  #   Sku Create (0.5ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 2], ["spec", "Gov. Bobby Wisoky"], ["quantity", 4], ["created_at", "2024-06-15 10:38:34.190315"], ["updated_at", "2024-06-15 10:38:34.190315"]]
  #   Sku Create (0.5ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 2], ["spec", "Pres. Blaine Strosin"], ["quantity", 2], ["created_at", "2024-06-15 10:38:34.191035"], ["updated_at", "2024-06-15 10:38:34.191035"]]
  #   Sku Create (0.3ms)  INSERT INTO "skus" ("product_id", "spec", "quantity", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["product_id", 2], ["spec", "Yael Larson"], ["quantity", 2], ["created_at", "2024-06-15 10:38:34.191747"], ["updated_at", "2024-06-15 10:38:34.191747"]]
  #   TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  # => #<Product:0x0000000117588078
  #  id: 2,
  #  name: "Sen. Sheree Heaney",
  #  vendor_id: 2,
  #  list_price: 0.53e2,
  #  sell_price: 0.21e2,
  #  on_sell: false,
  #  code: "0909190f17f3de4bb4f1",
  #  deleted_at: nil,
  #  created_at: Sat, 15 Jun 2024 10:38:34.187021000 UTC +00:00,
  #  updated_at: Sat, 15 Jun 2024 10:38:34.187021000 UTC +00:00,
  #  category_id: 2>
  # ---------
  # [4] pry(main)> p2.skus.count
  #  (2.8ms)  SELECT COUNT(*) FROM "skus" WHERE "skus"."product_id" = $1  [["product_id", 2]]
  #  => 5
