FactoryBot.define do
  factory :merchant do
    name { Faker::Commerce.vendor }

    factory :merchant_with_items do
      transient do
        num { 4 }
      end

      before(:create) do |merchant, options|
        create_list(:item, options.num, merchant: merchant)
      end
    end
  end
end
