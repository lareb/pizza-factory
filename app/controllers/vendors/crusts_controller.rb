# frozen_string_literal: true

module Vendors
  # CrustsController
  class CrustsController < BaseController
    def index
      @crusts = Crust.all
    end

    def new
      @crust = Crust.new
    end

    def create
      @crust = Crust.new(crust_params)
      if @crust.save
        flash[:notice] = '🍞 Crust added successfully!'
        redirect_to vendors_inventories_path
      else
        flash[:alert] = '⚠️ Failed to add crust. Please check your input.'
        render :new
      end
    end

    private

    def crust_params
      params.require(:crust).permit(:name)
    end
  end
end
