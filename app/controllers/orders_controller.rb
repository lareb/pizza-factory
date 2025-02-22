# frozen_string_literal: true

# OrdersController
class OrdersController < ApplicationController
  before_action :load_order_dependencies, only: %i[new create]

  def new
    @order = Order.new
  end

  def create
    result = Orders::CreationService.new(params).call

    if result.success?
      flash[:notice] = '✅ Order placed successfully!'
      redirect_to order_path(result.order)
    else
      flash[:alert] = "❌ #{result.errors.join(', ')}"
      redirect_to new_order_path
    end
  end

  def confirm
    @order = Order.find(params[:id])

    if @order.confirm!
      flash[:notice] = '✅ Order confirmed!'
      redirect_to order_path(@order)
    else
      flash[:alert] = '❌ Not enough inventory!'
      redirect_to new_order_path
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def load_order_dependencies
    @pizzas = Pizza.includes(:category).all
    @crusts = Crust.all
    @toppings = Topping.includes(:category).all
    @sides = Side.all
  end
end
