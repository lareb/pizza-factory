# frozen_string_literal: true

# OrderSide
class OrderSide < ApplicationRecord
  belongs_to :order
  belongs_to :side

  def price
    side.price
  end
end
