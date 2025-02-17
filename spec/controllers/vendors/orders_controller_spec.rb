# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vendors::OrdersController, type: :controller do
  let(:order) { create(:order) }
  let!(:order_side) { create(:order_side, order: order) }
  let!(:order_item) { create(:order_item, order: order) }
  let!(:order_topping) { create(:order_topping, order_item: order_item) }

  before do
    vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
    vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(vendor_username, vendor_password)
  end

  it_behaves_like 'a protected vendor controller'

  describe 'GET #index' do
    it 'assigns all orders to @orders' do
      order1 = create(:order)
      order2 = create(:order)

      get :index

      expect(assigns(:orders)).to include(order1, order2)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested order to @order' do
      get :show, params: { id: order.id }

      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'POST #confirm' do
    context 'when order is confirmed successfully' do
      before do
        allow_any_instance_of(Order).to receive(:confirm!).and_return(true)
        post :confirm, params: { id: order.id }
      end

      it 'sets a success flash message' do
        expect(flash[:notice]).to eq('✅ Order confirmed!')
      end

      it 'redirects to the order show page' do
        expect(response).to redirect_to(vendors_order_path(order))
      end
    end

    context 'when order confirmation fails' do
      before do
        allow_any_instance_of(Order).to receive(:confirm!).and_return(false)
        post :confirm, params: { id: order.id }
      end

      it 'sets an error flash message' do
        expect(flash[:alert]).to eq('❌ Not enough inventory!')
      end

      it 'redirects to the orders index page' do
        expect(response).to redirect_to(vendors_orders_path)
      end
    end
  end
end
