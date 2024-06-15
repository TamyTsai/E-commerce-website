FactoryBot.define do
  factory :order do
    num { "MyString" }
    recipient { "MyString" }
    tel { "MyString" }
    address { "MyString" }
    note { "MyText" }
    user { nil }
    state { "MyString" }
    paid_at { "2024-06-15 11:58:25" }
    transaction_id { "MyString" }
  end
end
