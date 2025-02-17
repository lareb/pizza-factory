# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    status { 'Pending' }
    total_price { 30.0 }
  end
end
