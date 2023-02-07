FactoryBot.define do
  factory :invoice do
    status { 0 }
    association :customer
  end
end