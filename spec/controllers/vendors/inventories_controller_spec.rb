# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vendors::InventoriesController, type: :controller do
  let(:pizza) { create(:pizza) }
  let(:crust) { create(:crust) }
  let(:topping) { create(:topping) }
  let(:inventory) { Inventory.find_by(item: pizza) }

  before do
    vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
    vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(vendor_username, vendor_password)
  end
  it_behaves_like 'a protected vendor controller'

  describe 'GET #index' do
    it 'assigns all inventories to @inventories' do
      get :index
      expect(assigns(:inventories)).to include(inventory)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid params' do
      it 'updates the inventory quantity' do
        put :update, params: { id: inventory.id, quantity: 20 }
        inventory.reload
        expect(inventory.quantity).to eq(20)
      end

      it 'sets a success flash message' do
        put :update, params: { id: inventory.id, quantity: 20 }
        expect(flash[:notice]).to eq('✅ Inventory updated successfully!')
      end

      it 'redirects to the inventories index' do
        put :update, params: { id: inventory.id, quantity: 20 }
        expect(response).to redirect_to(vendors_inventories_path)
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(Inventory).to receive(:update).and_return(false)
      end

      it 'does not update the inventory' do
        put :update, params: { id: inventory.id, quantity: nil }
        inventory.reload
        expect(inventory.quantity).to eq(10) # Quantity remains unchanged
      end

      it 'sets an error flash message' do
        put :update, params: { id: inventory.id, quantity: nil }
        expect(flash[:alert]).to eq('❌ Failed to update inventory or price. Please try again.')
      end

      it 'redirects to the inventories index' do
        put :update, params: { id: inventory.id, quantity: nil }
        expect(response).to redirect_to(vendors_inventories_path)
      end
    end
  end
end
