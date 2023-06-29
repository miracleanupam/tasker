require 'factory_bot'

FactoryBot.define do
  factory :user do
    name { Faker::TvShows::BojackHorseman.character }
    email { "#{name.gsub(' ', '.')}@hollywood.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    admin { false }
    activation_digest { nil }
    activated { true }
    activated_at { Time.zone.now }
  end
end
