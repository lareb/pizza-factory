# frozen_string_literal: true

# Pizza
class Pizza < ApplicationRecord
  validates :name, presence: true
  after_create :initialize_inventory

  belongs_to :category

  validates :name, presence: true

  private

  def initialize_inventory
    Inventory.create(item: self, quantity: 10) # Default stock
  end
end
