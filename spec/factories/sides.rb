# frozen_string_literal: true

FactoryBot.define do
  factory :side do
    name { Faker::Food.dish }
    price { 2.0 }
  end
end
