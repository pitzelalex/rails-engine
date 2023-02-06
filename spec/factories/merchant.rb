FactoryBot.define do
  factory :merchant do
    name { Faker::TvShows::RickAndMorty.location }
  end
end
