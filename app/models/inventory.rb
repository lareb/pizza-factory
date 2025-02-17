# frozen_string_literal: true

# Inventory
class Inventory < ApplicationRecord
  belongs_to :item, polymorphic: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  def self.available?(item, required_quantity)
    inventory = find_by(item: item)
    inventory && inventory.quantity >= required_quantity
  end

  def self.use_inventory(item, quantity)
    inventory = find_by(item: item)
    return false unless inventory && inventory.quantity >= quantity

    inventory.update(quantity: inventory.quantity - quantity)
  end
end
