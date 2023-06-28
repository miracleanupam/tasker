FactoryBot.define do
  factory :project do
    name { Faker::TvShows::BojackHorseman.character }
    user
  end
end
