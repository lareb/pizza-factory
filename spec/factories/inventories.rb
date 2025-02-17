# frozen_string_literal: true

FactoryBot.define do
  factory :inventory do
    association :item, factory: :pizza
    quantity { 10 }
  end
end
