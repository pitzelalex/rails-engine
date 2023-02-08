FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentences(number: 2) }
    unit_price { Faker::Commerce.price(range: 5.0..10000.0, as_string: true) }
    association :merchant
  end
end
