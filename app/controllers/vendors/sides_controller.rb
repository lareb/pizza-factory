# frozen_string_literal: true

module Vendors
  # SidesController
  class SidesController < BaseController
    def index
      @sides = Side.all
    end

    def new
      @side = Side.new
    end

    def create
      @side = Side.new(side_params)
      if @side.save
        flash[:notice] = '🍟 Side added successfully!'
        redirect_to vendors_inventories_path
      else
        flash[:alert] = '⚠️ Failed to add side. Please check your input.'
        render :new
      end
    end

    private

    def side_params
      params.require(:side).permit(:name, :price)
    end
  end
end
