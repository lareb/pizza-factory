# frozen_string_literal: true

FactoryBot.define do
  factory :order_topping do
    order_item
    topping
  end
end
