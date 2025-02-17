# frozen_string_literal: true

module Vendors
  # OrdersController
  class OrdersController < BaseController
    def index
      @orders = Order.includes({ order_sides: :side },
                               order_items: [:pizza, :crust,
                                             { order_toppings: :topping }])
                     .page(params[:page])
                     .per(PER_PAGE).order(created_at: :desc)
    end

    def show
      @order = Order.find(params[:id])
    end

    def confirm
      @order = Order.find(params[:id])

      if @order.confirm!
        flash[:notice] = '✅ Order confirmed!'
        redirect_to vendors_order_path(@order)
      else
        flash[:alert] = '❌ Not enough inventory!'
        redirect_to vendors_orders_path
      end
    end
  end
end
