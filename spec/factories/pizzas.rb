# frozen_string_literal: true

FactoryBot.define do
  factory :pizza do
    name { Faker::Food.dish }
    category
    price_regular { 10.0 }
    price_medium { 15.0 }
    price_large { 20.0 }
  end
end
