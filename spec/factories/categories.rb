FactoryBot.define do
  factory :category do
    name { Faker::Name.name }
    # position { 1 } # acts as list套件會幫我們處理
  end
end
