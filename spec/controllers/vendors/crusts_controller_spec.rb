# frozen_string_literal: true

# spec/controllers/vendors/crusts_controller_spec.rb

require 'rails_helper'

RSpec.describe Vendors::CrustsController, type: :controller do
  let(:valid_attributes) { { name: 'Thin Crust' } }
  let(:invalid_attributes) { { name: '' } }
  let!(:crust) { create(:crust) }

  before do
    vendor_username = Rails.application.credentials.dig(:vendors, :authentication, :username)
    vendor_password = Rails.application.credentials.dig(:vendors, :authentication, :password)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(vendor_username, vendor_password)
  end

  it_behaves_like 'a protected vendor controller'

  describe 'GET #index' do
    it 'assigns all crusts to @crusts' do
      get :index
      expect(assigns(:crusts)).to eq([crust])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Crust to @crust' do
      get :new
      expect(assigns(:crust)).to be_a_new(Crust)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Crust' do
        expect do
          post :create, params: { crust: valid_attributes }
        end.to change(Crust, :count).by(1)
      end

      it 'redirects to the vendors_inventories_path' do
        post :create, params: { crust: valid_attributes }
        expect(response).to redirect_to(vendors_inventories_path)
      end

      it 'sets a success flash message' do
        post :create, params: { crust: valid_attributes }
        expect(flash[:notice]).to eq('🍞 Crust added successfully!')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Crust' do
        expect do
          post :create, params: { crust: invalid_attributes }
        end.not_to change(Crust, :count)
      end

      it 'renders the new template' do
        post :create, params: { crust: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'sets an error flash message' do
        post :create, params: { crust: invalid_attributes }
        expect(flash[:alert]).to eq('⚠️ Failed to add crust. Please check your input.')
      end
    end
  end
end
