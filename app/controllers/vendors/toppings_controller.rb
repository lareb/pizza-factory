# frozen_string_literal: true

module Vendors
  # ToppingsController
  class ToppingsController < BaseController
    def index
      @toppings = Topping.all
    end

    def new
      @categories = Category.all
      @topping = Topping.new
    end

    def create
      @topping = Topping.new(topping_params)
      if @topping.save
        flash[:notice] = '🍖 Topping added successfully!'
        redirect_to vendors_inventories_path
      else
        flash[:alert] = '⚠️ Failed to add topping. Please check your input.'
        render :new
      end
    end

    private

    def topping_params
      params.require(:topping).permit(:name, :category_id, :price)
    end
  end
end
