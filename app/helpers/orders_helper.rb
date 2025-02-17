# frozen_string_literal: true

module OrdersHelper
  def order_status_color(status)
    case status
    when 'Pending'
      'bg-yellow-500'  # Warning equivalent
    when 'Confirmed'
      'bg-green-500'   # Success equivalent
    when 'Cancelled'
      'bg-red-500'     # Danger equivalent
    else
      'bg-gray-500'    # Secondary equivalent
    end
  end

  def pizza_price(pizza, size)
    case size
    when 'regular' then pizza.price_regular
    when 'medium' then pizza.price_medium
    when 'large' then pizza.price_large
    else 0
    end
  end
end
