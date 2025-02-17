# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vendors::ToppingsController, type: :controller do
  let(:category) { create(:category) }
  let(:topping) { create(:topping, category: category) }

  before do
    vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
    vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(vendor_username, vendor_password)
  end

  it_behaves_like 'a protected vendor controller'

  describe 'GET #index' do
    it 'assigns all toppings to @toppings' do
      topping1 = create(:topping, category: category)
      topping2 = create(:topping, category: category)

      get :index

      expect(assigns(:toppings)).to include(topping1, topping2)
    end
  end

  describe 'GET #new' do
    it 'assigns a new topping to @topping' do
      get :new
      expect(assigns(:topping)).to be_a_new(Topping)
    end

    it 'assigns all categories to @categories' do
      category1 = create(:category)
      category2 = create(:category)

      get :new

      expect(assigns(:categories)).to match_array([category1, category2])
    end
  end

  describe 'POST #create' do
    context 'when topping is created successfully' do
      let(:valid_params) do
        {
          topping: {
            name: 'Pepperoni',
            category_id: category.id
          }
        }
      end

      it 'creates a new topping' do
        expect { post :create, params: valid_params }.to change(Topping, :count).by(1)
      end

      it 'sets a success flash message' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('🍖 Topping added successfully!')
      end

      it 'redirects to vendors_inventories_path' do
        post :create, params: valid_params
        expect(response).to redirect_to(vendors_inventories_path)
      end
    end

    context 'when topping creation fails' do
      let(:invalid_params) do
        {
          topping: {
            name: '',
            category_id: nil
          }
        }
      end

      it 'does not create a new topping' do
        expect { post :create, params: invalid_params }.not_to change(Topping, :count)
      end

      it 'sets an error flash message' do
        post :create, params: invalid_params
        expect(flash[:alert]).to eq('⚠️ Failed to add topping. Please check your input.')
      end

      it 're-renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end
end
