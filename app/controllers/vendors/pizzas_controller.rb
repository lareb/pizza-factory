# frozen_string_literal: true

module Vendors
  # PizzasController
  class PizzasController < BaseController
    def index
      @pizzas = Pizza.includes(:category).page(params[:page]).per(PER_PAGE).order(created_at: :desc)
    end

    def new
      @categories = Category.all
      @pizza = Pizza.new
    end

    def create
      @pizza = Pizza.new(pizza_params)
      if @pizza.save
        flash[:notice] = '🍕 Pizza added successfully!'
        redirect_to vendors_inventories_path
      else
        flash[:alert] = '⚠️ Failed to add pizza. Please check your input.'
        render :new
      end
    end

    private

    def pizza_params
      params.require(:pizza).permit(:name, :category_id, :price_regular, :price_medium, :price_large)
    end
  end
end
