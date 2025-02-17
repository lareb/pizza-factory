# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    order
    pizza
    crust
    size { 'regular' }
  end
end
