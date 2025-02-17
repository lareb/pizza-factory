# frozen_string_literal: true

# Order
class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :order_sides, dependent: :destroy

  before_save :calculate_total_price

  validates :status, inclusion: { in: %w[Pending Confirmed Cancelled] }

  def calculate_total_price
    self.total_price = order_items.sum(&:price) + order_sides.sum(&:price)
  end

  def can_be_fulfilled?
    order_items.all? { |item| Inventory.available?(item.pizza, 1) } &&
      order_items.all? { |item| Inventory.available?(item.crust, 1) } &&
      order_sides.all? { |side| Inventory.available?(side.side, 1) } &&
      order_items.all? do |order_item|
        order_item.order_toppings.all? do |item|
          Inventory.available?(item.topping, 1)
        end
      end
  end

  def confirm!
    if can_be_fulfilled?
      order_items.each { |item| Inventory.use_inventory(item.pizza, 1) }
      order_items.each { |item| Inventory.use_inventory(item.crust, 1) }
      order_items.each do |order_item|
        order_item.order_toppings.each do |item|
          Inventory.use_inventory(item.topping, 1)
        end
      end
      order_sides.each { |side| Inventory.use_inventory(side.side, 1) }
      update(status: 'Confirmed')
    else
      errors.add(:base, 'Insufficient inventory')
      false
    end
  end
end
