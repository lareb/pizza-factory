# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vendors::PizzasController, type: :controller do
  let(:category) { create(:category) }
  let(:pizza) { create(:pizza, category: category) }

  before do
    vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
    vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(vendor_username, vendor_password)
  end

  it_behaves_like 'a protected vendor controller'

  describe 'GET #index' do
    it 'assigns all pizzas to @pizzas' do
      pizza1 = create(:pizza, category: category)
      pizza2 = create(:pizza, category: category)

      get :index

      expect(assigns(:pizzas)).to include(pizza1, pizza2)
    end
  end

  describe 'GET #new' do
    it 'assigns a new pizza to @pizza' do
      get :new
      expect(assigns(:pizza)).to be_a_new(Pizza)
    end

    it 'assigns all categories to @categories' do
      category1 = create(:category)
      category2 = create(:category)

      get :new

      expect(assigns(:categories)).to match_array([category1, category2])
    end
  end

  describe 'POST #create' do
    context 'when pizza is created successfully' do
      let(:valid_params) do
        {
          pizza: {
            name: 'Margherita',
            category_id: category.id,
            price_regular: 10.99,
            price_medium: 14.99,
            price_large: 18.99
          }
        }
      end

      it 'creates a new pizza' do
        expect { post :create, params: valid_params }.to change(Pizza, :count).by(1)
      end

      it 'sets a success flash message' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('🍕 Pizza added successfully!')
      end

      it 'redirects to vendors_inventories_path' do
        post :create, params: valid_params
        expect(response).to redirect_to(vendors_inventories_path)
      end
    end

    context 'when pizza creation fails' do
      let(:invalid_params) do
        {
          pizza: {
            name: '',
            category_id: nil,
            price_regular: nil
          }
        }
      end

      it 'does not create a new pizza' do
        expect { post :create, params: invalid_params }.not_to change(Pizza, :count)
      end

      it 'sets an error flash message' do
        post :create, params: invalid_params
        expect(flash[:alert]).to eq('⚠️ Failed to add pizza. Please check your input.')
      end

      it 're-renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end
end
