# frozen_string_literal: true

FactoryBot.define do
  factory :order_side do
    order
    side
  end
end
