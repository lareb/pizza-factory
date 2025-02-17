# frozen_string_literal: true

# Crust
class Crust < ApplicationRecord
  has_many :order_items

  after_create :initialize_inventory

  validates :name, presence: true

  private

  def initialize_inventory
    Inventory.create(item: self, quantity: 10) # Default stock
  end
end
