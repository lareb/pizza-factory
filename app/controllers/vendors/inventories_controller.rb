# frozen_string_literal: true

module Vendors
  # InventoriesController
  class InventoriesController < BaseController
    def index
      @inventories = Inventory.includes(:item).page(params[:page]).per(PER_PAGE).order(created_at: :desc)
    end

    def update
      inventory = Inventory.find(params[:id])
      item = inventory.item

      Inventory.transaction do
        inventory.update!(quantity: params[:quantity])
        if inventory.item_type == 'Pizza'
          if item.respond_to?(:price_regular) && item.respond_to?(:price_medium) && item.respond_to?(:price_large)
            item.update!(price_regular: params[:price_regular], price_medium: params[:price_medium],
                         price_large: params[:price_large])
          end
        elsif %w[Topping Side].include?(inventory.item_type)
          item.update!(price: params[:price]) if item.respond_to?(:price)
        end
      end

      flash[:notice] = '✅ Inventory updated successfully!'
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = '❌ Failed to update inventory or price. Please try again.'
    ensure
      redirect_to vendors_inventories_path
    end
  end
end
