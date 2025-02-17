# frozen_string_literal: true

# OrderValidator
class OrderValidator
  attr_reader :order, :errors

  def initialize(order)
    @order = order
    @errors = []
  end

  def valid?
    validate_toppings
    validate_crust
    validate_large_pizza_toppings
    errors.empty?
  end

  private

  # Rule 1: Vegetarian pizza cannot have non-vegetarian toppings
  # Rule 2: Non-vegetarian pizza cannot have paneer topping
  # Rule 4: Only one non-veg topping for non-veg pizza
  def validate_toppings
    order.order_items.each do |order_item|
      toppings = order_item.order_toppings.map(&:topping)
      veg_toppings = toppings.select { |t| t.category.name == 'Vegetarian' || t.category.name == 'Paneer' }
      non_veg_toppings = toppings.select { |t| t.category.name == 'Non-Vegetarian' }

      if order_item.pizza.category.name == 'Vegetarian' && non_veg_toppings.any?
        errors << 'Vegetarian pizza cannot have non-vegetarian toppings.'
      end

      if order_item.pizza.category.name == 'Non-Vegetarian' && veg_toppings.any? { |t| t.category.name == 'Paneer' }
        errors << 'Non-vegetarian pizza cannot have paneer topping.'
      end

      if order_item.pizza.category.name == 'Non-Vegetarian' && non_veg_toppings.count > 1
        errors << 'Only one non-veg topping can be added to a non-vegetarian pizza.'
      end
    end
  end

  # Rule 3: Only one type of crust per pizza
  def validate_crust
    order.order_items.group_by(&:pizza_id).each do |_pizza_id, items|
      errors << 'Only one type of crust can be selected per pizza.' if items.map(&:crust_id).uniq.size > 1
    end
  end

  # Rule 5: Large size pizzas come with 2 free toppings
  def validate_large_pizza_toppings
    order.order_items.each do |order_item|
      if order_item.size == 'large' && order_item.order_toppings.size < 2
        errors << 'Large pizzas come with 2 free toppings. Extra toppings will be charged.'
      end
    end
  end
end
