FactoryBot.define do
  factory :task do
    description { Faker::TvShows::BojackHorseman.quote }
    status { Faker::Number.between(from: 0, to: 4) }
    project
  end
end
