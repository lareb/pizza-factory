# frozen_string_literal: true

# Topping
class Topping < ApplicationRecord
  has_many :order_toppings
  belongs_to :category

  after_create :initialize_inventory

  validates :name, presence: true

  private

  def initialize_inventory
    Inventory.create(item: self, quantity: 10) # Default stock
  end
end
