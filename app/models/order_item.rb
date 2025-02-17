# frozen_string_literal: true

# OrderItem
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :pizza
  belongs_to :crust
  has_many :order_toppings, dependent: :destroy

  enum :size, %i[regular medium large]

  def price
    base_price = case size
                 when 'regular' then pizza.price_regular
                 when 'medium' then pizza.price_medium
                 when 'large' then pizza.price_large
                 else 0
                 end

    # Sort toppings by price (highest first) and exclude top 2 prices if size is large
    topping_prices = order_toppings.map(&:price).sort.reverse
    discount_topping_prices = size == 'large' ? topping_prices.drop(2) : topping_prices

    base_price + discount_topping_prices.sum
  end
end
