FactoryBot.define do
  factory :vendor do # 用factory方法
    # 如此一來 測試時 就可以 透過 FactoryBot.create(:vendor) 直接在測試資料庫建一筆資料 （找到vendors資料表 呼叫vendor model 建立物件）
    # 如果不想直接存進資料庫 可以寫 FactoryBot.build(:vendor)

    title { Faker::Name.name } # 廠商名稱欄位要填的值
    # Faker::Name.name 請faker幫我們作假名稱資料出來
    description { Faker::Lorem.paragraph }
    # 請faker長廢文出來
    online { true }

  end
end

# RAILS_ENV=test rails c
# [1] pry(main)> FactoryBot.build(:vendor)
# => #<Vendor:0x000000010463dc88 id: nil, title: "Chad Walsh Esq.", description: "Magnam eos enim. Et qui omnis. Sint iste quisquam.", online: true, created_at: nil, updated_at: nil, deleted_at: nil>
