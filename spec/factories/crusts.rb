# frozen_string_literal: true

FactoryBot.define do
  factory :crust do
    name { Faker::Food.dish }
  end
end
