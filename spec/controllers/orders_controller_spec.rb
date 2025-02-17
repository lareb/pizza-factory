# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:order_params) do
    {
      order_items: [
        { pizza_id: create(:pizza).id, size: 'medium', crust_id: create(:crust).id, topping_ids: [create(:topping).id] }
      ],
      side_ids: [create(:side).id]
    }
  end
  let(:order) { create(:order) }

  describe 'GET #new' do
    it 'assigns @order and renders the new template' do
      get :new

      expect(assigns(:order)).to be_a_new(Order)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'when the order is successfully created' do
      before do
        allow(Orders::CreationService).to receive(:new).and_return(double(call: double(success?: true, order: order)))
      end

      it 'redirects to the order path with a success notice' do
        post :create, params: { order: order_params }

        expect(flash[:notice]).to eq('✅ Order placed successfully!')
        expect(response).to redirect_to(order_path(order))
      end
    end

    context 'when the order creation fails' do
      before do
        allow(Orders::CreationService).to receive(:new).and_return(double(call: double(success?: false,
                                                                                       errors: ['Invalid order'])))
      end

      it 'redirects to the new order path with an alert message' do
        post :create, params: { order: order_params }

        expect(flash[:alert]).to eq('❌ Invalid order')
        expect(response).to redirect_to(new_order_path)
      end
    end
  end

  describe 'GET #confirm' do
    context 'when the order is successfully confirmed' do
      before do
        allow(order).to receive(:confirm!).and_return(true)
        allow(Order).to receive(:find).and_return(order)
      end

      it 'redirects to the order path with a success notice' do
        get :confirm, params: { id: order.id }

        expect(flash[:notice]).to eq('✅ Order confirmed!')
        expect(response).to redirect_to(order_path(order))
      end
    end

    context 'when the order cannot be confirmed due to insufficient inventory' do
      before do
        allow(order).to receive(:confirm!).and_return(false)
        allow(Order).to receive(:find).and_return(order)
      end

      it 'redirects to the new order path with an alert message' do
        get :confirm, params: { id: order.id }

        expect(flash[:alert]).to eq('❌ Not enough inventory!')
        expect(response).to redirect_to(new_order_path)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns @order and renders the show template' do
      get :show, params: { id: order.id }

      expect(assigns(:order)).to eq(order)
      expect(response).to render_template(:show)
    end
  end

  describe 'private methods' do
    describe '#load_order_dependencies' do
      it 'loads the necessary dependencies for the order creation form' do
        allow(controller).to receive(:load_order_dependencies).and_call_original
        get :new
        expect(assigns(:pizzas)).to eq(Pizza.includes(:category).all)
        expect(assigns(:crusts)).to eq(Crust.all)
        expect(assigns(:toppings)).to eq(Topping.includes(:category).all)
        expect(assigns(:sides)).to eq(Side.all)
      end
    end
  end
end
