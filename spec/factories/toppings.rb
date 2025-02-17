# frozen_string_literal: true

FactoryBot.define do
  factory :topping do
    name { Faker::Food.dish }
    price { 2.0 }
    category
  end
end
