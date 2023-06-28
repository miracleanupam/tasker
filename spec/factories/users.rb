require 'factory_bot'

FactoryBot.define do
  factory :user do
    name { Faker::TvShows::BojackHorseman.character }
    email { Faker::Internet.email(domain: 'anupamdahal.com.np') }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    admin { false }
    activation_digest { nil }
    activated { true }
    activated_at { Time.zone.now }
  end
end
