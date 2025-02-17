# frozen_string_literal: true

module Orders
  # CreationService
  class CreationService
    Result = Struct.new(:success?, :order, :errors)

    def initialize(params)
      @params = params
    end

    def call
      order = Order.new(status: 'Pending')

      ActiveRecord::Base.transaction do
        build_order_items(order)
        build_order_sides(order)

        validator = OrderValidator.new(order)
        if validator.valid?
          order.save!
          return Result.new(true, order, [])
        else
          return Result.new(false, [], validator.errors)
        end
      end
    rescue ActiveRecord::RecordInvalid, StandardError => e
      Result.new(false, nil, [e.message])
    end

    private

    def build_order_items(order)
      return unless @params[:order][:order_items].present?

      @params[:order][:order_items].each do |item|
        raise 'Invalid pizza or crust selection.' if item[:pizza_id].nil? || item[:crust_id].nil?
        raise "Size can't be blank" if item[:size].nil?

        pizza = Pizza.find_by(id: item[:pizza_id])
        crust = Crust.find_by(id: item[:crust_id])

        order_item = order.order_items.build(pizza: pizza, crust: crust, size: item[:size].downcase)

        if item[:topping_ids].present?
          toppings = Topping.where(id: item[:topping_ids])
          toppings.each { |topping| order_item.order_toppings.build(topping: topping) }
        end
      end
    end

    def build_order_sides(order)
      return unless @params[:side_ids].present?

      sides = Side.where(id: @params[:side_ids])
      sides.each { |side| order.order_sides.build(side: side) }
    end
  end
end
