# frozen_string_literal: true

# Category
class Category < ApplicationRecord
  has_many :pizzas, dependent: :destroy
  has_many :toppings, dependent: :destroy

  validates :name, presence: true
end
