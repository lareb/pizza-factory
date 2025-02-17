# frozen_string_literal: true

# Side
class Side < ApplicationRecord
  has_many :order_sides

  after_create :initialize_inventory

  validates :name, presence: true

  private

  def initialize_inventory
    Inventory.create(item: self, quantity: 10) # Default stock
  end
end
