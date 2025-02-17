# frozen_string_literal: true

# OrderTopping
class OrderTopping < ApplicationRecord
  belongs_to :order_item
  belongs_to :topping

  def price
    topping.price
  end
end
